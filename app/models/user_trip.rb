class UserTrip < ActiveRecord::Base
  belongs_to :user
  belongs_to :trip

  #if it doesn't exist, creates a usertrip object, associating the user with the trip
  #this trip will be set to 'created by user'
  #RET: returns the UserTrip
  def self.createUserTrip(user_id, trip_id)
    ut = UserTrip.find_by_user_id_and_trip_id(user_id, trip_id)

    #create user trip if its not already associated
    if ut.nil? and user_id != 0 #user id of 0 means there is no user
      ut = UserTrip.new
      ut.user_id = user_id
      ut.trip_id = trip_id
      ut.created_by_user = true
      ut.save
    end

    return ut
  end

end
