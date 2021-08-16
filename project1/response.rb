class Response
  def initialize(code:, data:)
    time = "<div>#{Time.now}</div>"
    @response =
      "HTTP/1.1 #{code}\r\n" +
      "Content-Type: text/html; charset=utf-8\r\n" + # to prevent warning in browser console
      "Content-Length: #{data.size + time.size}\r\n" +
      "\r\n" +
      "#{data}\r\n" +
      "#{time}"
  end

  def send(client)
    client.write(@response)
  end
end
