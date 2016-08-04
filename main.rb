require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'geocoder'

require_relative 'db_config'


require_relative 'models/comment'
require_relative 'models/painting'
require_relative 'models/user'
require_relative 'models/like'



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
  User.find_by(id: session[:user_id])
end


def index
  if params[:search].present?
    @locations = Location.near(params[:search], 50, :order => :distance)
  else
    @locations = Location.all
  end
end



def googLocation
  Painting.connection
end



get '/' do

  @paintings = Painting.all
  @liked_paintings = Painting.joins(:likes).group(:painting_id).count(:painting_id)
  @top_ordered_paintgs = Painting.select("count(painting_id) as likes_count, title, img_url, paintings.id")
    .joins(:likes)
    .group('painting_id, title, img_url, paintings.id')
    .order('likes_count desc')
  # @top_ordered_paintgs.save

  erb :index
end



#  ******* CREATE SESSION
post '/session' do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect to '/'
  else
    redirect back
  end
end


delete '/session' do
    session[:user_id] = nil
    redirect to '/'
end



#  ******* SIGN UP
get '/signup' do
  erb :signup
end


post '/signup' do

  user = User.new
  user.name = params[:user_name]
  user.email = params[:user_email]
  user.password = params[:user_password]
  user.save

  session[:id] = user.id

  redirect '/'
end


get '/my_album' do
  @paintings = current_user.paintings
  erb :my_album
end



#  ******* LIKE FUNCTIONALITY
put '/painting/:id/likes' do
   @painting = Painting.find_by(id: params[:id])

  if logged_in?
    if current_user.likes.find {|like| like.painting_id == @painting.id} == nil
      @like = Like.new
      @like.painting_id = params[:id]
      @like.user_id = current_user.id
      @like.save
      @painting.likes << @like
    end
  end
  redirect back
end



#                    ******* CREATE NEW POSITION
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



#   *********************************************************
#                    ******* DISPLAY PAINTING'S DETAILS
get '/painting_detail/:id' do

  @painting = Painting.find(params[:id])
  # @location = Geocoder.coordinates(@painting.city)

  @all_comments = @painting.comments.all
  erb :painting_detail
end

#   ********************************************************



get '/results' do
    @painting = Painting.find_by(title: params[:painting_search])
    # @all_comments = @painting.comments
  # binding.pry
  if @painting
    redirect to "/painting_detail/#{@painting.id}"
    # erb :painting_detail                                #this is silly Magda>>, need to redirct
  else
    redirect back
  end
end



#                        ******* EDIT PAINTING
get '/painting/:id/edit' do
  @user = User.find_by(email: params[:email])
  @painting = Painting.find(params[:id])
  if logged_in? && @painting.user_id == current_user.id
    erb :edit
  else
    redirect '/'
  end
end


put '/painting/:id/edit' do
  @painting = Painting.find(params[:id])
  # binding.pry
  @painting.update(title: params[:title], img_url: params[:img_url], author: params[:author], century: params[:century], style: params[:style], seen_live: params[:seen_live], city: params[:city], museum: params[:museum ])
  redirect to "/painting_detail/#{params[:id]}"
end



#                        ******* DELETE PAINTING
delete '/painting/:id' do
  painting = Painting.find(params[:id])
  painting.destroy
  redirect to "/my_album"
end



#                         ******* COMMENT FUNCTIONALITY
post '/painting/:id' do
  @comment = Comment.new
  @comment.comment = params[:comment]
  @comment.painting_id = params[:id]
  @comment.user_id = current_user.id
  @comment.save
  @painting = Painting.find(params[:id])
  @all_comments = @painting.comments.all
  redirect to "/painting_detail/#{params[:id]}"
end


delete '/paintings/delete/:id' do
  @comment = Comment.find(params[:id])
  @comment.destroy
  redirect back
end


put '/paintings/update_comment/:id' do
  @comment = Comment.where(painting_id: params[:id], user_id: current_user.id)
  @comment = Comment.find(params[:id])
  @comment.update(comment: params[:comment])
  redirect back
end







# <%= image_tag "http://maps.google.com/maps/api/staticmap?size=450x300&sensor=false&zoom=16&markers=#{@location.latitude}%2C#{@location.longitude}" %>
#
#   <ul>
#   <% for location in @location.nearbys(10) %>
#     <li><%= link_to location.city, location %> (<%= location.distance.round(2) %> miles)</li>
#   <% end %>
#   </ul>


# in models/paintings.rb:
# # geocoded_by :city  #use column name
# # after_validation :geocode
# end





# mb@g.co > cake
#dt@ga.co > pudding
#dz@.com > nope
#harry@.ga > bot
#s@.co > 123123
