require 'thin'
require_relative 'timeloggermiddleware'
require_relative 'temperaturemiddleware'
require_relative 'application'

use TimeLoggerMiddleware
use TemperatureMiddleWare
run Application.new
