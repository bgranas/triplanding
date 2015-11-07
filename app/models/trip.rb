class Trip < ActiveRecord::Base
  has_many :user_trips
  has_many :users, :through => :user_trips
  has_many :destination_orders
  has_many :destinations, :through => :destination_orders
end
