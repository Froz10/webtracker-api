require_relative './modules/validator'
require_relative './lib/api/tracker'
require_relative './db/storage'

require 'json'
require 'redis'
require 'uri'
require 'pry'

use Rack::Reloader
run Api::Tracker
