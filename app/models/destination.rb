class Destination < ActiveRecord::Base
  has_many :destination_orders
  has_many :trips, :through => :destination_orders
  has_many :photos
end
