#!/usr/bin/ruby
require 'erb'
require 'optparse'

require_relative 'file_utils'
require_relative 'renderer'

include FileUtils
include Renderer

markdown_folder = nil
template_folder = nil
result_folder = nil

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

  opts.on_tail("-h", "--help", "Show help message") do
    puts opts
    exit
  end
end.parse!

if !markdown_folder
  puts 'ERROR: unspecified markdown folder'
  exit
end
if !template_folder
  puts 'ERROR: unspecified template folder'
  exit
end
if !result_folder
  puts 'ERROR: unspecified destination folder'
  exit
end
# end of command line parsing


puts 'Jerk takes the stage...'

# For each folder in the markdown folder,
# grab the corresponding template file, and
# try to render it
page_list = list_subfolders markdown_folder
page_list.each do |folder_name|
  content_path = full_path markdown_folder, folder_name
  template_path = full_path template_folder, "#{folder_name}.html.erb"
  result_path = full_path result_folder, "#{folder_name}.html"
  @base_template_file = nil

  env = {
    :content_path => content_path,
    :template_folder => template_folder
  }
  template_erb = ERB.new open(template_path).read
  content = template_erb.result(binding)
  if @base_template_file # then, wrap with base template
    base_template_path = full_path template_folder, @base_template_file
    partial_title = nil || @partial_title
    base_erb = ERB.new open(base_template_path).read
    content = base_erb.result(binding)
  end
  write_html result_path, content
end

puts 'Jerk backs off. Everything is settled for you.'
