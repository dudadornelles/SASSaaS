require 'sass'
require 'sinatra'
require 'open-uri'
require 'net/http'
require 'fileutils'
require 'compass'
require './lib/dependencies'
require './lib/path'

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
  end

  set :sass, Compass.sass_engine_options
  set :scss, Compass.sass_engine_options
  set :port, 80
end

get '/compile' do
  file_url_dir, folder_path, main_filename = url_parts(request[:f])
  project_folder = File.join('views', folder_path)

  # XXX: better check for filetype and return 422 in case it isnt sass or scss
  filetype = main_filename.match(/\.sass$/) ? :sass : :scss

  uri = URI.parse(request[:f])
  http = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https')
  remote_dir = File.dirname(uri.path)

  download_deps_of(remote_dir, main_filename, project_folder, filetype.to_s, http) unless File.exists?(File.join(folder_path, main_filename))

  to_render = File.join(folder_path, File.basename(main_filename, '.*')).to_sym
  self.send(filetype, to_render)
end

