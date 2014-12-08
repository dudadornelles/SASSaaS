class HttpClient
  attr_reader :scheme

  def initialize(uri)
    uri = URI.parse(uri)
    @scheme = uri.scheme
    @http = Net::HTTP.start(uri.host, uri.port, :use_ssl => @scheme == 'https')
  end

  def get(path, file)
    try_file = File.join(path, file)
    response = @http.get(try_file)
    return response.body if response.class == Net::HTTPOK

    try_file = File.join(path, "_#{file}")
    response = @http.get(try_file)
    return response.body
  end

end

