require 'sinatra'
require 'dotenv'

require_relative 'lib/notifier'

Dotenv.load

post '/' do
  request.body.rewind  # in case someone already read it
  data = JSON.parse request.body.read
  Notifier.instance.ping(data['message'])
  200
end
