
def download_deps_of(path, name, project)
  save_and_get_deps(path, name, project).each {|dep| download_deps_of(path, dep, project) }
end

def save_and_get_deps(path, name, project)
  return [] if File.exists?(File.join(project, name))

  begin
    f = open(File.join(path, "_#{name}"))
  rescue
    f = open(File.join(path, name))
  end

  content = f.read
  open(File.join(project, name), 'w') do |f|
    f.puts(content)
    f.close
  end
  # return dependencies
  content.scan(/@import "(.*?)"/).flatten.select {|e| !e.match('compass/') }
end

