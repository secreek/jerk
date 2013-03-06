#!/usr/bin/ruby
require 'erb'
require_relative 'file_utils'
require_relative 'renderer'

include FileUtils
include Renderer

puts 'Jerk takes the stage...'

markdown_folder = './example/markdown'
template_folder = './example/templates'
result_folder = './example/results'

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
    base_erb = ERB.new open(base_template_path).read
    content = base_erb.result(binding)
  end
  write_html result_path, content
end

puts 'Jerk backs off.'
