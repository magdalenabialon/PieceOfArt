require 'sinatra'
require 'sinatra/reloader'
require 'pry'

require_relative 'db_config'

require_relative 'models/comment'
require_relative 'models/painting'
require_relative 'models/user'



enable :sessions




get '/' do
  erb :index
end


post '/session' do
  "Hello World"
end
