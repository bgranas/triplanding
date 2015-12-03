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
    elsif ut and user_id !=0 and not ut.created_by_user #usertrip exists, but has only favoirted trip
      ut.created_by_user = true
      ut.save
    end

    return ut
  end


  #if UserTrip exists and is favorited, unfavorites
  #otherwise, calls favorite_trip
  def self.toggle_favorite(user_id, trip_id)
    return nil if user_id == 0 #if invalid user, return nil

    ut = UserTrip.find_by_user_id_and_trip_id(user_id, trip_id)
    if ut and ut.favorited_by_user
      return UserTrip.unfavorite_trip(ut)
    else
      return UserTrip.favorite_trip(ut, user_id, trip_id)
    end
  end

  #favorites trip_id for the user specified
  #if user is already associated to trip, sets favorited by user = true
  #if user is not associated to trip, creates new UserTrip object
  #returns UserTrip object
  def self.favorite_trip(ut, user_id, trip_id)
    if ut.nil?
      ut = UserTrip.new
      ut.user_id = user_id
      ut.trip_id = trip_id
      ut.favorited_by_user = true
    else #user already has row associated to trip
      ut.favorited_by_user = true
    end

    ut.save

    return ut
  end

  #unfavorites trip for the user specified
  #returns UserTrip object or nil if it doesn't exist
  def self.unfavorite_trip(ut)
    if ut
      ut.favorited_by_user = false
      ut.save
    end

    return ut
  end

end
