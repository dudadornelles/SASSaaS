require 'sass'
require 'sinatra'
require 'open-uri'
require 'net/http'
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
  return if File.exists?("#{path}/#{name}")

  begin
    f = open("#{path}/_#{name}")
  rescue
    f = open("#{path}/#{name}")
  end

  content = f.read
  open("#{project}/#{name}", "w") do |f|
    f.puts(content)
    f.close
  end
  # return dependencies
  content.scan(/@import "(.*?)"/).flatten.select {|e| !e.match("compass/") }
end

get '/compile/:project' do |project|
  project_folder = "views/#{project}"
  url = request[:file]
  name = File.basename(url)
  path = File.dirname(url)
  FileUtils.mkdir_p(project_folder)
  filetype = name.match(/\.sass$/) ? :sass : :scss

  download_deps_of(path, name, project_folder) if !File.exists?("#{project_folder}/#{name}")
  self.send(filetype, "#{project}/#{name.gsub(/\.scss/,'')}".to_sym)
end
