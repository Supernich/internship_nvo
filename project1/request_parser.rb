class RequestParser
  def parse(request:)
    method, path, _version = request.lines[0].split

    { method: method, path: path }
  end
end
