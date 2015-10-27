module TripDisplayHelper

	def trip_display_setup


		# Trip object attributes
		@tripTitle = "Vietnam North to South"
		@tripMapStaticSize = "350x300"
		@tripMapStatic = "https://www.google.com/maps/api/staticmap?size="+@tripMapStaticSize+"&path=weight:5|Hanoi,Vietnam|Halong,Vietnam|Hue,Vietnam|DaLat,Vietnam|HoChiMinhCity,Vietnam" # Google static map URL
		@tripCity = ["Hanoi","Ho Chi Minh City","Da Nang","Da Lat","Mui Ne","Test1","Test2"] #all cities included in Trip
		@tripCountry = ["Vietnam"] #all countries included in Trip
		@tripScore = 10
		@numTripShares = 3

		#Whether this trip is wishlist, confirmed, or neither
		@travelConfirmStatus = 2 #0 = no user input, 1 = wishlist, 2 = confirmed (past travel or currently booked on our site)

		# Trip's User atributes
		@username = "User12345" # trip creator's username
		@profilePicture = "paradise-feature-sm.jpg" # trip creator's profile pictre

		#List of regions for map sorting
		@regions = ["Asia","Americas","Europe","Africa","India","Oceania"]
	end

end
