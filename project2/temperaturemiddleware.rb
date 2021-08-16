require "ArseniysWeatherApp"

class TemperatureMiddleWare
  def initialize(app)
    @app = app
  end

  def call(env)
    temperature = ArseniysWeatherApp::Weather.new.my_fact_temperature
    status, header, body = @app.call(env)
    body << "<div>Your outside temperature #{temperature}C</div>\r\n"
    [status, header, body]
  end
end
