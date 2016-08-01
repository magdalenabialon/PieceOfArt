require 'sinatra'
require 'sinatra/reloader'
require 'pry'

require_relative 'db_config'

require_relative 'models/comment'
require_relative 'models/painting'
require_relative 'models/user'



enable :sessions

helpers do
  def logged_in?
    if User.find_by(id: session[:user_id])
      return true
    else
      return false
    end
  end
end


def current_user
  User.find(session[:user_id])
end




get '/' do
  erb :index
end


post '/session' do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect to '/'
  else
    erb :index
  end
end


delete '/session' do
    session[:user_id] = nil
    redirect to '/'
end



get '/my_album' do
  erb :my_album
end


get '/results' do
  "Hello World"
  # sql = "SELECT * FROM pokemon WHERE species = '#{params["species"]}';"
  # @pokem = run_sql(sql)[0]
  # erb :results
end
























# [2] pry(main)> u1=User.new  => #<User:0x007fb1ab5c0c10 id: nil, name: nil, email: nil, password_digest: nil>
# [3] pry(main)> u1.name = 'magda'  => "magda"
# [4] pry(main)> u1.email = 'mb@g.co'  => "mb@g.co"
# [5] pry(main)> u1.password = 'cake'  => "cake"

# [8] pry(main)> u2 = User.new  => #<User:0x007fb1ab713a40 id: nil, name: nil, email: nil, password_digest: nil>
# [9] pry(main)> u2.name = 'dt'   => "dt"
# [10] pry(main)> u2.email = 'dt@ga.co'  => "dt@ga.co"
# [11] pry(main)> u2.password = 'pudding'  => "pudding"
