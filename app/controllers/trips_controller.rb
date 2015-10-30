class TripsController < ApplicationController

  layout 'application'

  def index

    @map_page = true

    # Static map API link builder
    @tripMapStaticSize = "300x300"
    @tripMapStatic = "https://www.google.com/maps/api/staticmap?size="+@tripMapStaticSize+"&scale=2&path=weight:5|Hanoi,Vietnam|Halong,Vietnam|Hue,Vietnam|DaLat,Vietnam|HoChiMinhCity,Vietnam" # Google static map URL
    #@tripMapStaticDestination = ["Hanoi","Da Nang","Da Lat","Mui Ne","Ho Chi Minh City"]   # Build City, Country items for URL

    # Trip object attributes
    @tripID = 1 # Unique trip ID identifier
    @tripTitle = "Vietnam North to South"
    @tripDestination = ["Hanoi, Vietnam"] #etc...     # is this needed or can we parse city and country without it?
    @tripCity = ["Hanoi","Ho Chi Minh City","Da Nang","Da Lat","Mui Ne"] #all cities included in Trip
    @tripCountry = ["Vietnam"] #all countries included in Trip
    @likeTotal = "20" # total likes received on this Trip
    @tripStartDate = "August 2015" #Date trip taken - all fields optional
    @tripEndDate = "September 2015" #Optional
    @tripDate = @tripStartDate + " - " + @tripEndDate

    #Whether this trip is wishlist, confirmed, or neither
    @travelConfirmStatus = 1 #0 = wishlist if @tripDate == null, 1 = confirmed if @tripDate !== null

    # Trip's User atributes
    @username = "User12345" # trip creator's username
    @profilePicture = "paradise-feature-sm.jpg" # trip creator's profile picture

    #List of regions for map sorting
    @regions = ["Asia","Americas","Europe","Africa","India","Oceania"]
  end

  def show
  end

  def delete
  end

  def edit
  end

  def new
  end
end
