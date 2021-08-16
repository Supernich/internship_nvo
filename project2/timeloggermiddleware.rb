class TimeLoggerMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    before = Time.now.to_i
    status, header, body = @app.call(env)
    after = Time.now.to_i

    body << "<div>Done at #{after - before} seconds</div>\r\n"
    [status, header, body]
  end
end
