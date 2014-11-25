require 'uri'

def url_parts(url)
  file_url_dir = File.dirname(url)
  url = URI.parse(url)
  folder_path = File.join(url.host, File.dirname(url.path))
  filename = File.basename(url.path)

  return file_url_dir, folder_path, filename
end
