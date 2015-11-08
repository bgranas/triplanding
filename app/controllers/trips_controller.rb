class TripsController < ApplicationController

  layout 'nav_bar_only', :only => [:new, :edit]
  include TransportationHelper


  def index

    # add initialization script for google maps
    @map_page = true



    # Static map API link builder
    @tripMapStaticSize = "300x300"
    @tripMapStatic = "https://www.google.com/maps/api/staticmap?size="+@tripMapStaticSize+"&scale=2&path=weight:5|Hanoi,Vietnam|Halong,Vietnam|Hue,Vietnam|DaLat,Vietnam|HoChiMinhCity,Vietnam&key=AIzaSyBbL1jb6SbG8RGQME134WvJeJbd6PJEFSw" # Google static map URL
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
    @map_page = true
  end

  def delete
  end

  def edit
    @map_page = true
  end

  def new
    # add initialization script for google maps
    @map_page = true





    @trip = Trip.create #creates/saves a trip object


    @itineraryOriginDate = "1"
    @itineraryOriginTransportation = "Flight from SFO to PVG"
    @itineraryOriginSpecifics = "American Airlines flight 1 | 9:00 AM"
    @itineraryOriginPrice = "$1000"


    @itineraryStepOrder = "1"
    @itineraryStepDate = "2"
    @itineraryStepCity = "Shanghai"
    @itineraryStepCountry = "CHINA"

    @accommodationType = "Hotel"
    @accommodationSpecifics = "2 nights in ABC Hotel | Check in: Jan 1 Check out: Jan 3"
    @accommodationPrice = "$100"

    #if true renders destination selection in itinerary, if false renders "add next destination" button
    @destinationChosen = true
    #if true renders transport selection in itinerary, if false renders transport search with r2r call
    @transportChosen = true
    #if true renders accomm selection in itinerary, if false renders accomm search
    @accommChosen = true

    

    @transportationType = "Bus"
    @itineraryStepDestination2 = "Dafeng"
    @transportationSpecifics = "DF Bus | Shanghai Bus Station | 12:00 PM"
    @transportationPrice = "$15"

    @originCoords = "31.157,121.40" #might have a max number of digits
    @destinationCoords = "10.09,99.83806"

    #calling TransportationHelper
    r2r_call

  end

  def itinerary_test
        # add initialization script for google maps
    @map_page = true


    @itineraryOriginDate = "1"
    @itineraryOriginTransportation = "Flight from SFO to PVG"
    @itineraryOriginSpecifics = "American Airlines flight 1 | 9:00 AM"
    @itineraryOriginPrice = "$1000"


    @itineraryStepOrder = "1"
    @itineraryStepDate = "2"
    @itineraryStepCity = "Shanghai"
    @itineraryStepCountry = "CHINA"

    @accommodationType = "Hotel"
    @accommodationSpecifics = "2 nights in ABC Hotel | Check in: Jan 1 Check out: Jan 3"
    @accommodationPrice = "$100"

    #if true renders destination selection in itinerary, if false renders "add next destination" button
    @destinationChosen = true
    #if true renders transport selection in itinerary, if false renders transport search with r2r call
    @transportChosen = true
    #if true renders accomm selection in itinerary, if false renders accomm search
    @accommChosen = true

    

    @transportationType = "Bus"
    @itineraryStepDestination2 = "Dafeng"
    @transportationSpecifics = "DF Bus | Shanghai Bus Station | 12:00 PM"
    @transportationPrice = "$15"

    @originCoords = "31.157,121.40" #might have a max number of digits
    @destinationCoords = "10.09,99.83806"

    #calling TransportationHelper
    r2r_call
  end


  def new_destination
    @dest = Destination.new
  end

end
