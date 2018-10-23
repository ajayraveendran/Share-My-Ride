require 'sinatra'
require 'sinatra/reloader'
require 'pry'

# has_many :owned_bikes, class_name: 'Bike', foreign_key: 'owner_id'
# belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/bike'
require_relative 'models/booking'

enable :sessions

helpers do

  def current_user
    User.find_by(id: session[:user_id])
  end
  
  def logged_in?
    !!current_user #if current user exists then returns true (not truthey) as def current user returns the user id, 
    # if current user doesn't exist then as double negation returns boolean, in this case it'll be false (not falsey).
  end
  
end

get '/' do
  @bikes = Bike.all #almost an array of hashes..
  erb :index
end


get '/login' do
  erb :login
end

post '/session' do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect to('/')
  else
    erb :login
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect to('/')
end

get '/user/new' do
  erb :new
end

post '/user' do
  user = User.new
  user.name = params[:name]
  user.username = params[:username]
  user.email = params[:email]
  user.password = params[:password]
  user.dob = params[:dob]
  user.suburb = params[:suburb]
  user.save
  redirect to('/login')
end

get '/user/:id' do
  @user = User.find(params[:id])
  @owned_bikes = @user.owned_bikes
  erb :show
end

get '/user/:id/edit' do
  @user = User.find(params[:id])
  erb :edit
end

put '/user/:id' do
  user = User.find(params[:id])
  user.name = params[:name]
  user.username = params[:username]
  user.suburb = params[:suburb]
  user.dob = params[:dob]
  user.save
  redirect to("/user/#{params[:id]}")
end

delete '/user/:id' do
  user = User.find(params[:id])
  user.destroy
  redirect to('/')
end

get '/bike/new' do
  # erb :new
end

post '/bike' do
  bike = Bike.new
  bike.owner_id = current_user.id
  bike.make = params[:make]
  bike.model = params[:model]
  bike.lams = params[:lams]
  bike.save
  redirect to("/user/#{current_user.id})
end


