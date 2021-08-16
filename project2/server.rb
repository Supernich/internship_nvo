require 'rack'
require 'thin'
require_relative 'timeloggermiddleware'
require_relative 'temperaturemiddleware'
require_relative 'application'

Rack::Handler::Thin.run(
  TemperatureMiddleWare.new(Application.new)
)
