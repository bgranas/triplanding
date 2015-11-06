class Trip < ActiveRecord::Base
  has_many :user_trips
end
