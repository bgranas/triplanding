class UsersController < ApplicationController

	layout 'application'

	include TripDisplayHelper

	def show
		@page_title = "User 123" + "\'s Profile"
		#User info
		@username = "User 123"
		@profilePicture = "paradise-feature-sm.jpg" # user's profile picture
		@userBlogURL = "www.myblog.com" # user's blog (optional)
		@userHomeCity = "San Francisco" # user's home city
		@userHomeCountry = "USA" # user's home country

		#User scores
		@numTrips = 5  # number of trips user has created
		@upvoteScore = 20 # user reputation score
		@numCountriesVisited = 5 # total number of countries present in user's created trips

		# User's trips
		# @userTrips = [trip IDs with @userID = user's ID]
		# @userFavoriteTrips = [trip IDs of favorited trips stored here]

		#calling Trip Display helper
    trip_display_setup

    #To prevent username from displaying on trip list
    @show_username = false;

	end

end
