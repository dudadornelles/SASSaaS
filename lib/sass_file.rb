require 'uri'

class SassFile

  attr_reader :fs_file_path, :filetype

  def initialize(uri, http)
    uri = URI.parse(uri)

    @http = http
    @path = File.dirname(uri.path)
    @file = File.basename(uri.path)
    @host = uri.host

    @fs_folder_path = File.join('views', @host, @path)
    @fs_file_path = File.join(@fs_folder_path, @file)
    @filetype = @file.match(/\.sass/) ? :sass : :scss

    download_main
    download_dependencies
  end

  def download_main
    content = @http.get(@path, @file)
    @dependencies = content.scan(/@import "(.*?)"/).flatten.select {|e| !e.match('compass/') }
    save(content)
  end

  def to_render_path
    @fs_file_path.gsub(/\.s[ac]ss$/, '').gsub(/^views\//, '').to_sym
  end

  def download_dependencies
    @dependencies.each do |d|
      dep_uri = "#{@http.scheme}://#{File.join(@host, @path, "#{d}.#{@filetype.to_s}")}"
      SassFile.new(dep_uri, @http)
    end
  end

  def save(content)
    FileUtils.mkdir_p(@fs_folder_path)
    open(@fs_file_path, 'w') { |f| f.puts content }
  end

end
