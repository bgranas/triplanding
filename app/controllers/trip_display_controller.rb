class TripDisplayController < ApplicationController


	def index
		@tripTitle = "Vietnam North to South"
		@tripMapStatic = "https://www.google.com/maps/api/staticmap?size=275x300&path=weight:5|Hanoi,Vietnam|Halong,Vietnam|Hue,Vietnam|DaLat,Vietnam|HoChiMinhCity,Vietnam"
		@tripCountry = "Vietnam"
		@upvoteScore = 10
	end

	def regionSort
		@regions = ["Asia","Americas","Europe","Africa","India","Oceania"]

	end

end
