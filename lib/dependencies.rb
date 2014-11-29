require 'uri'
require 'net/http'

def download_deps_of(remote_dir, name, project, filetype, http)
  save_and_get_deps(remote_dir, name, project, filetype, http).each {|dep| download_deps_of(remote_dir, dep, project, filetype, http) }
end

def name_with_underscore(name)
  return name.match('/') ? 
         File.join(File.dirname(name), "_#{File.basename(name)}") :
         "_#{File.basename(name)}"
end

def get_file(remote_dir, name, filetype, http)
  name = name.match(filetype) ? name : "#{name}.#{filetype}"
  if name =~ /hide-text/
    require 'byebug';byebug
  end

  try_name = File.join(remote_dir, name)
  response = http.get(try_name)
  return response.body, name  if response.class == Net::HTTPOK

  try_name = File.join(remote_dir, name_with_underscore(name))
  response = http.get(try_name)
  return response.body, name
end

def save_and_get_deps(remote_dir, name, project, filetype, http)
  return [] if File.exists?(File.join(project, name))

  content, name = get_file(remote_dir, name, filetype, http)

  to_save = File.join(project, name)
  FileUtils.mkdir_p(File.dirname(to_save))
  open(to_save, 'w') do |f|
    f.puts(content)
    f.close
  end

  # return dependencies
  content.scan(/@import "(.*?)"/).flatten.select {|e| !e.match('compass/') }
end

