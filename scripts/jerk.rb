#!/usr/bin/ruby
require 'erb'
require 'optparse'
require 'json'

require_relative 'file_utils'
require_relative 'renderer'

include FileUtils
include Renderer

markdown_folder = nil
template_folder = nil
result_folder = nil
config_file_path = nil

# Parses command line arguments
OptionParser.new do |opts|
  opts.banner = "Usage: jerk.rb [options]"

  opts.on("-m", "--markdown MARKDOWN_FOLDER", "Path to markdown files") do |m|
    markdown_folder = m
  end

  opts.on("-t", "--template TEMPLATE_FOLDER", "Path to template files") do |t|
    template_folder = t
  end

  opts.on("-d", "--destination DESTINATION_FOLDER", "Path to save the rendered html files") do |d|
    result_folder = d
  end

  opts.on("-c", "--config CONFIG_FILE_PATH", "Some configuration stuff for the rendering process") do |c|
    config_file_path = c
  end

  opts.on_tail("-h", "--help", "Show help message") do
    puts opts
    exit
  end
end.parse!

# if !markdown_folder
#   puts 'ERROR: unspecified markdown folder'
#   exit
# end
if !template_folder
  puts 'ERROR: unspecified template folder'
  exit
end
if !result_folder
  puts 'ERROR: unspecified destination folder'
  exit
end
# end of command line parsing

@config = {}
if config_file_path
  conf_content = open(config_file_path).read() 
  @config = JSON.load(conf_content)  if conf_content
end

puts 'Jerk takes the stage...'

def build(env, templ_str)
  conf = @config
  @base_template_file = nil
  template_erb = ERB.new templ_str
  content = template_erb.result(binding)
  if @base_template_file # then, wrap with base template
    base_template_path = full_path template_folder, @base_template_file
    @base_template_file = base_template_path if File.exists base_template_path
    base_erb_content = fetch @base_template_file
    partial_title = nil || @partial_title
    base_erb = ERB.new base_erb_content
    content = base_erb.result(binding)
  end
  content
end

jerk_site_file = "#{template_folder}/jerk.json"
if File.exists? jerk_site_file then
  # Use sitemap instead of template folders
  jerk_site = JSON.load(open(jerk_site_file).read())
  sitemap = jerk_site['sitemap']
  jerk_site["sitemap"].each do |page, templ_uri|
    env = nil;
    templ_str = fetch templ_uri
    content = build(env, templ_str)
    result_path = full_path result_folder, page
    write_html result_path, content
  end
else
  # For each folder in the markdown folder,
  # grab the corresponding template file, and
  # try to render it
  page_list = list_subfolders markdown_folder
  page_list.each do |folder_name|
    content_path = full_path markdown_folder, folder_name
    template_path = full_path template_folder, "#{folder_name}.html.erb"

    env = {
      :content_path => content_path,
      :template_folder => template_folder
    }

    content = build(env, open(template_path).read)

    result_path = full_path result_folder, "#{folder_name}.html"
    write_html result_path, content
  end
end

puts 'Jerk backs off. Everything is settled for you.'
