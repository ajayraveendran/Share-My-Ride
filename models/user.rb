class User < ActiveRecord::Base
  has_secure_password # add 3 methods for you 
  #.password, >> reads password (gets)
  #.password = , >> sets password AND column name in table needs to be password_digest!!
  #.authenticate >> 
  has_many :owned_bikes, class_name: 'Bike', foreign_key: 'owner_id'
  has_many :bookings
  has_many :bikes, :through => :bookings
end