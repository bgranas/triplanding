class TripsController < ApplicationController

  layout 'nav_bar_only', :only => [:new, :edit, :itinerary_test]


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


    #calling TransportationHelper
    #r2r_call

  end

  def create
    trip_id = params[:trip_id].to_i
    trip_title = params[:trip_title]
    countries = params[:countries]
    cities = params[:cities]
    distance = params[:distance]

    destinationIDs = params[:destinationIDs]
    departure_city_id = params[:departure_city_id]
    return_city_id = params[:return_city_id]

    @trip = Trip.find_by_id(trip_id) #trip ID should be created when user first goes to page
    @trip.title = trip_title #setting title
    @trip.countries = countries
    @trip.cities = cities
    @trip.distance = distance #in KM
    @trip.departure_city_destination_id = departure_city_id
    @trip.return_city_destination_id = return_city_id
    @trip.save

    #first, delete all existing destination orders
    DestinationOrder.where(trip_id: trip_id).delete_all
    #next, create destination orders and associate them with my trip
    createDestinationOrders(destinationIDs, trip_id)

    #last, associate this trip to the user
    user_id = params[:user_id].to_i
    ut = UserTrip.find_by_user_id_and_trip_id(user_id, trip_id)

    if ut.nil? #create user trip if its not already associated
      ut = UserTrip.new
      ut.user_id = user_id
      ut.trip_id = trip_id
      ut.created_by_user = true
      ut.save
    end

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

    #initializing variables to be passed to trips.coffee via ajax
    @airportPathsLng = []
    @airportPathsLat = []
    @routePaths = []

  end

  def new_destination
    @dest = Destination.new
  end

private

  #creates Destination order objects from an array of destinationIDs
  def createDestinationOrders(destinationIDs, trip_id)
    order_authority = 100
    destinationIDs.each do |destID|
      DestinationOrder.create(destination_id: destID, trip_id: trip_id, order_authority: order_authority)
      order_authority = order_authority + 100
    end
  end

end
