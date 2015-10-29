class UsersController < ApplicationController

	layout 'application'

	include TripDisplayHelper

  before_action :verify_is_admin, only: [:index]


  #List all users for admins to view/edit/delete
	def index
    @page_title = 'Edit Users'

		@users = User.order("created_at ASC")
	end

	def show

		#User info
		@user = User.find(params[:id])

		@page_title = @user.name + "\'s Profile"

		#User scores placeholders for now
		@numTrips = 5  # number of trips user has created
		@upvoteScore = 20 # user reputation score
		@numCountriesVisited = 5 # total number of countries present in user's created trips

		#calling Trip Display helper
    trip_display_setup

    #To prevent username from displaying on trip list
    @show_username = false;

	end


  def delete
    @user = User.find_by_id(params[:id])
  end

  def destroy
    @user = User.find_by_id(params[:id])
    @user.destroy
    redirect_to(:action => 'index')
  end

end
