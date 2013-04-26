require 'fileutils'
require 'net/http'
require 'uri'

module FileUtils

  def list_subfolders parent_path
    Dir.entries(parent_path).select {|entry| File.directory? File.join(parent_path, entry) and !(entry =='.' || entry == '..') }
  end

  def full_path parent_path, folder_path
    File.join(parent_path, folder_path)
  end

  def write_html file_path, content
    dir = File.dirname(file_path)
    FileUtils.mkdir_p dir unless File.directory? dir
    begin
      file = File.open(file_path, "w")
      file.write(content)
    rescue IOError => e
      #some error occur, dir not writable etc.
      puts e
    ensure
      file.close unless file == nil
    end
  end

  def grab_web uri_str
      url = URI.parse(uri_str)      
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https') if uri_str.start_with? 'https://'
      request = Net::HTTP::Get.new(url.path)
      puts "Grabbing document from\t #{uri_str}"
      response = http.start {|http| http.request(request) }
      puts "Done."
      response.body
  end
  
  # TODO - Cached
  def fetch uri_str
    if uri_str.start_with?("http://", "https://")
      return grab_web uri_str
    else
      return open(uri_str).read
    end
  end

end
