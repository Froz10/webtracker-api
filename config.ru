require_relative './module/validator'
require_relative './api/tracker'
require_relative './db/storage'


require 'json'
require 'pry'
require 'redis'
require 'open-uri'
require 'uri'

use Rack::Reloader
run API::Tracker