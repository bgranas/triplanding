module TripDisplayHelper

	def trip_display_setup


		# Static map API link builder
		@tripMapStaticSize = "300x300"
		@tripMapStatic = "https://www.google.com/maps/api/staticmap?size="+@tripMapStaticSize+"&scale=2&path=weight:5|Hanoi,Vietnam|Halong,Vietnam|Hue,Vietnam|DaLat,Vietnam|HoChiMinhCity,Vietnam" # Google static map URL
		#@tripMapStaticDestination = ["Hanoi","Da Nang","Da Lat","Mui Ne","Ho Chi Minh City"]   # Build City, Country items for URL 

		# Trip object attributes
		@tripID = 1 # Unique trip ID identifier
		@tripTitle = "Vietnam North to South"
		@tripCity = ["Hanoi","Ho Chi Minh City","Da Nang","Da Lat","Mui Ne"] #all cities included in Trip
		@tripCountry = ["Vietnam"] #all countries included in Trip
		@likeTotal = "20" # total likes received on this Trip

		#Whether this trip is wishlist, confirmed, or neither
		@travelConfirmStatus = 2 #0 = no user input, 1 = wishlist, 2 = confirmed (past travel or currently booked on our site)

		# Trip's User atributes
		@username = "User12345" # trip creator's username
		@profilePicture = "paradise-feature-sm.jpg" # trip creator's profile pictre

		#List of regions for map sorting
		@regions = ["Asia","Americas","Europe","Africa","India","Oceania"]
	end

end
