require 'sass'
require 'sinatra'
require 'open-uri'
require 'fileutils'
require 'compass'

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
  end

  set :haml, { :format => :html5 }
  set :sass, Compass.sass_engine_options
  set :scss, Compass.sass_engine_options
  set :port, 80
end


def download_deps_of(path, name, project)
  deps = save_and_get_deps(path, name, project)
  unless deps.empty?
    deps.each {|dep| download_deps_of(path, dep, project) }
  end
end


def save_and_get_deps(path, name, project)
  puts name
  f = open("#{path}/#{name}")
  content = f.read
  open("#{project}/#{name}", "w") do |f|
    f.puts(content)
    f.close
  end
  # return dependencies
  content.scan(/@import "(.*?)"/).flatten.select {|e| !e.match("compass/") }.map {|f| "_#{f}"}
end

get '/compile/:project' do |project|
  old_project = project
  project = "views/#{project}"

  FileUtils.mkdir_p(project)

  url = request[:file]
  name = File.basename(url)
  path = File.dirname(url)
  download_deps_of(path, name, project)

  scss "#{old_project}/#{name.gsub(/\.scss/,'')}".to_sym
end
