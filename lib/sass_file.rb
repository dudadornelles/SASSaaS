require 'uri'
require 'fileutils'

class SassFile

  attr_reader :fs_file_path, :filetype

  def initialize(uri, http, clean_cache=false)
    uri = URI.parse(uri)

    @http = http
    @path = File.dirname(uri.path)
    @file = File.basename(uri.path)
    @host = uri.host

    @fs_folder_path = File.join('views', @host, @path)
    @fs_file_path = File.join(@fs_folder_path, @file)
    @filetype = @file.match(/\.sass/) ? :sass : :scss

    if clean_cache
      FileUtils.rm_rf(@fs_folder_path)
    end

    download_main
    download_dependencies
  end
  
  def scan_deps(content)
    content.scan(/@import "(.*?)"/).flatten.select {|e| !e.match('compass/') }
  end

  def download_main
    if File.exists?(@fs_file_path)
      @dependencies = scan_deps(open(@fs_file_path).read)
      return
    end
    content = @http.get(@path, @file)
    @dependencies = scan_deps(content)
    save(content)
  end

  def to_render_path
    @fs_file_path.gsub(/\.s[ac]ss$/, '').gsub(/^views\//, '').to_sym
  end

  def download_dependencies
    @dependencies.each do |d|
      dep_file = d =~ /\.s[ac]ss$/ ? d : "#{d}.#{@filetype.to_s}"
      dep_uri = "#{@http.scheme}://#{File.join(@host, @path, dep_file)}"
      SassFile.new(dep_uri, @http)
    end
  end

  def save(content)
    FileUtils.mkdir_p(@fs_folder_path)
    open(@fs_file_path, 'w') { |f| f.puts content }
  end

end
