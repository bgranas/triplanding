class BetaController < ApplicationController
  def index
    @transparent_nav = true

    #Trip Display variables
    @tripTitle = "Vietnam North to South"
		@tripMapStatic = "https://www.google.com/maps/api/staticmap?size=275x300&path=weight:5|Hanoi,Vietnam|Halong,Vietnam|Hue,Vietnam|DaLat,Vietnam|HoChiMinhCity,Vietnam"
		@tripCountry = "Vietnam"
		@upvoteScore = 10
		@username = "User12345"

  end

  def about
  end

  def contact
  end
end
