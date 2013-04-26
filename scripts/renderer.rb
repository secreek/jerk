require 'rdiscount'

module Renderer
  attr_accessor :base_template_file
  attr_accessor :partial_title

  def set_base_template base_file
    @base_template_file = base_file
  end

  def set_partial_title title
    @partial_title = title
  end

  def render_partial env, prefix, item_template=nil
    result = ""
    if prefix.start_with?("http://", "https://")
      content = grab_web(prefix);
      result = RDiscount.new(content).to_html
    else
      content_path = env[:content_path]
      Dir[content_path + "/#{prefix}-*.md"].each do |file|
        html = RDiscount.new(open(file).read).to_html
        /.*#{prefix}-(\d\.)*(.*).md$/ =~ file
        # FIXME - Where is filename used?
        filename = "#$2" # add filename as part of the input parameters
        if item_template
          item_template_path = "#{env[:template_folder]}/#{item_template}"
          html = ERB.new(open(item_template_path).read).result(binding)
        end

        result += html
      end
    end
    result
  end

end
