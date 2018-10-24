require 'sinatra'
require 'sinatra/reloader'
require 'pry'

# has_many :owned_bikes, class_name: 'Bike', foreign_key: 'owner_id'
# belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/bike'
require_relative 'models/booking'
require 'date'

enable :sessions

helpers do

  def current_user
    User.find_by(id: session[:user_id])
  end
  
  def logged_in?
    !!current_user #if current user exists then returns true (not truthey) 
    # as def current user returns the user id, 
    # if current user doesn't exist then as double negation returns boolean, 
    # in this case it'll be false (not falsey).
  end
  
end

get '/' do
  @bikes = Bike.all #almost an array of hashes..
  erb :"/index"
end


get '/login' do
  erb :"/login"
end

post '/session' do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect to('/')
  else
    erb :"/login"
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect to('/')
end

# USER routes

get '/user/new' do
  erb :"users/new"
end
#create user
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
# read user
get '/user/:id' do
  @user = User.find(params[:id])
  @owned_bikes = @user.owned_bikes
  @user_bookings = Booking.where(renter_id: @user)
  erb :"users/show"
end
# show edit page
get '/user/:id/edit' do
  @user = User.find(params[:id])
  erb :"users/edit"
end
# edit user
put '/user/:id' do
  user = User.find(params[:id])
  user.name = params[:name]
  user.username = params[:username]
  user.suburb = params[:suburb]
  user.dob = params[:dob]
  user.save
  redirect to("/user/#{params[:id]}")
end
# delete user
delete '/user/:id' do
  user = User.find(params[:id])
  user.destroy
  redirect to('/')
end

#BIKE routes
get '/bike/new' do
  erb :"bikes/new"
end
#create bike
post '/bike' do
  bike = Bike.new
  bike.owner_id = current_user.id
  bike.year = params[:year]
  bike.make = params[:make]
  bike.model = params[:model]
  bike.lams = params[:lams]
  bike.image_url = params[:image_url]
  bike.daily_rate = params[:daily_rate]
  bike.save
  redirect to("/user/#{current_user.id}")
end
#read bike
get '/bike/:id' do
  @bike = Bike.find(params[:id])
  @owner = User.find(@bike.owner_id)
  erb :"bikes/show"
end
#show edit page
get '/bike/:id/edit' do
  @bike = Bike.find(params[:id])
  erb :"bikes/edit"
end
#update bike
put '/bike/:id' do
  bike = Bike.find(params[:id])
  bike.year = params[:year]
  bike.make = params[:make]
  bike.model = params[:model]
  bike.lams = params[:lams]
  bike.image_url = params[:image_url]
  bike.daily_rate = params[:daily_rate]
  bike.save
  redirect to("/bike/#{params[:id]}")
end
#delete bike
delete '/bike/:id' do
  bike = Bike.find(params[:id])
  bike.destroy
  redirect to("/user/#{current_user.id}")
end

#link to booking current bike on page
get '/booking/bike/:bike_id' do
  @bike = Bike.find(params[:bike_id])
  @owner = User.find(@bike.owner_id)
  @today = Date.today
  @today_plus_1_year = @today + 365
  erb :"bookings/new"
end

# read booking
get '/booking/:id' do
  @booking = Booking.find(params[:id])
  @bike = Bike.find(@booking.bike_id)
  @owner = User.find(@bike.owner_id)
  erb :"bookings/show"
end

# create booking
post '/booking' do
  booking = Booking.new
  booking.renter_id = current_user.id
  booking.bike_id = params[:bike_id]
  booking.booking_start = params[:booking_start]
  booking.save
  redirect to("/user/#{current_user.id}")
end

#show edit page
get '/booking/:id/edit' do
  @booking = Booking.find(params[:id])
  erb :"bookings/edit"
end

# update booking
put '/booking/:id' do
  @today = Date.today.iso8601
  @today_plus_1_year = (Date.today + 365).iso8601
  booking = Booking.find(params[:id])
  booking.booking_start = params[:booking_start]
  booking.save
  redirect to("/booking/#{params[:id]}")
end

#delete bike
delete '/booking/:id' do
  booking = Booking.find(params[:id])
  booking.destroy
  redirect to("/user/#{current_user.id}")
end