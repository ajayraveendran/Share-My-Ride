require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'share_my_ride'
}

ActiveRecord::Base.establish_connection(options)