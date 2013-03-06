require 'rdiscount'

module Renderer
  attr_accessor :base_template_file

  def set_base_template base_file
    @base_template_file = base_file
  end

  def render_partial env, prefix, item_template=nil
    result = ""
    content_path = env[:content_path]
    Dir[content_path + "/#{prefix}*.md"].each do |file|
      html = RDiscount.new(open(file).read).to_html
      if item_template
        item_template_path = "#{env[:template_folder]}/#{item_template}"
        html = ERB.new(open(item_template_path).read).result(binding)
      end

      result += html
    end

    result
  end

end
