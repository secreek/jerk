module FileUtils

  def list_subfolders parent_path
    Dir.entries(parent_path).select {|entry| File.directory? File.join(parent_path, entry) and !(entry =='.' || entry == '..') }
  end

  def full_path parent_path, folder_path
    File.join(parent_path, folder_path)
  end

  def write_html file_path, content
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

end
