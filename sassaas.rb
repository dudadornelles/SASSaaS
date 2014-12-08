require 'sass'
require 'sinatra'
require 'compass'
require './lib/sass_file'
require './lib/http_client'

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
  end

  set :sass, Compass.sass_engine_options
  set :scss, Compass.sass_engine_options
  set :port, 80
end

get '/compile' do
  http = HttpClient.new(request[:f])
  clean_cache =  request[:clean] || false
  sass_file = SassFile.new(request[:f], http, clean_cache)

  self.send(sass_file.filetype, sass_file.to_render_path)
end

