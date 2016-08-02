require 'sinatra'
require 'sinatra/reloader'
require 'pry'

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
  User.find(session[:user_id])
end





def num_likes
  # @painting = Painting.find_by(id: params[:id])
  @number_of_paintings = @paintings.size
  @painting = Painting.find(8)
  binding.pry
  @likes = @painting.likes.size
  # @num_us_likes = current_user.likes
  # @painting.liked_by

  # @num_painting_likes = @painting.likes.size


  # @likes= @like.painting_id.size          # ****  o.likes # all likes for o **
end






get '/' do
  @paintings = Painting.all
  erb :index
end


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



get '/my_album' do
  @paintings = current_user.paintings

  #CALL MY FUNCTION to show likes
  num_likes

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
  @all_comments = @painting.comments.all
  erb :painting_detail
end




get '/results' do
    @painting = Painting.find_by(title: params[:painting_search])
  # binding.pry
  if @painting
    erb :painting_detail
  else
    redirect back
  end
end




get '/painting/:id/edit' do
  @user = User.find_by(email: params[:email])
  if @user && @user.authenticate(params[:password])
    @painting = Painting.find(params[:id])
    erb :edit
  end
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



post '/painting/:id' do

  @comment = Comment.new
  @comment.comment = params[:comment]
  @comment.painting_id = params[:id]
  @comment.user_id = current_user.id
  @comment.save
    # binding.pry
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



# <form action="/painting/<%= @painting.id/like %>" method="post">
#    <p></p>
#    <button>Like</button>
# </form>
















# [2] pry(main)> u1=User.new  => #<User:0x007fb1ab5c0c10 id: nil, name: nil, email: nil, password_digest: nil>
# [3] pry(main)> u1.name = 'magda'  => "magda"
# [4] pry(main)> u1.email = 'mb@g.co'  => "mb@g.co"
# [5] pry(main)> u1.password = 'cake'  => "cake"

# [8] pry(main)> u2 = User.new  => #<User:0x007fb1ab713a40 id: nil, name: nil, email: nil, password_digest: nil>
# [9] pry(main)> u2.name = 'dt'   => "dt"
# [10] pry(main)> u2.email = 'dt@ga.co'  => "dt@ga.co"
# [11] pry(main)> u2.password = 'pudding'  => "pudding"
