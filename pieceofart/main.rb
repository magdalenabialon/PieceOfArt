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
  @paintings = current_user.paintings
  # binding.pry
  erb :my_album
end



get '/create' do
  erb :create
end


post '/create' do
  if !logged_in?
    redirect to '/'
  end

    @painting = Painting.new
    @painting.title = params[:title]
    @painting.img_url = params[:img_url]
    @painting.author = params[:author]
    @painting.century = params[:century]
    @painting.style = params[:style]
    @painting.seen_live = params[:seen_live]
    @painting.city = params[:city]
    @painting.museum = params[:museum]
    @painting.user_id = current_user.id
    @painting.save

    redirect to "/my_album?#{@painting.id}"

end



get '/painting_detail/:id' do
  @painting = Painting.find(params[:id])
  erb :painting_detail
end



get '/results/' do
  # sql = "SELECT * FROM pokemon WHERE species = '#{params["species"]}';"
  # @pokem = run_sql(sql)[0]
  @painting = Painting.find(params[:title])
  erb :results
end



get '/painting/:id/edit' do
  @painting = Painting.find(params[:id])
  erb :edit
end


put '/painting/:id/edit' do
  painting = Painting.find(params[:id])
  painting.update(title: params[:title], img_url: params[:img_url], author: params[:author], century: params[:century], style: params[:style], seen_live: params[:seen_live], city: params[:city], museum: params[:museum ])
  redirect to "/painting_detail/#{params[:id]}"
end


delete '/painting/:id' do
  painting = Painting.find(params[:id])
  painting.destroy
  redirect to "/my_album"
end









# [2] pry(main)> u1=User.new  => #<User:0x007fb1ab5c0c10 id: nil, name: nil, email: nil, password_digest: nil>
# [3] pry(main)> u1.name = 'magda'  => "magda"
# [4] pry(main)> u1.email = 'mb@g.co'  => "mb@g.co"
# [5] pry(main)> u1.password = 'cake'  => "cake"

# [8] pry(main)> u2 = User.new  => #<User:0x007fb1ab713a40 id: nil, name: nil, email: nil, password_digest: nil>
# [9] pry(main)> u2.name = 'dt'   => "dt"
# [10] pry(main)> u2.email = 'dt@ga.co'  => "dt@ga.co"
# [11] pry(main)> u2.password = 'pudding'  => "pudding"
