class DestinationsController < ApplicationController

  layout 'admin'

  include HTTParty

  def index
    @page_title = 'Edit Destinations'
    @destinations = Destination.order("created_at ASC")
  end

  def create
    debug = true
    place = JSON.parse params[:place]

    #use destination if already in the DB, otherwise create a new one
    dest = Destination.find_by_google_place_id(place['place_id'])
    if dest.nil?
      puts '******** New destination! gathering photos and place info' if debug
      dest = buildDestinationFromPlace(place)
      dest.save
      getPanoramiaPhotos(dest, 'thumbnail')
    else
      puts '******** OLD destination! gathering photos and place info' if debug
    end


    thumbnail_url = dest.destination_photos.first.photo_file_url if not dest.destination_photos.first.nil?
    if dest.persisted?
      render :json => {id: dest.id, country: dest.country, country_code: dest.country_iso_2,
                       thumbnail_url: thumbnail_url}
    else
      render :status => '400'
    end

=begin
    trip_id = params[:trip_id].to_i
    #Should only create destination order if a trip_id is defined
    if not trip_id.nil?
      max_order_auth = DestinationOrder.where(trip_id: trip_id).maximum(:order_authority)

      #if set destination order to 100 if first destination, else 100 + last destination
      new_order_auth = max_order_auth.nil? ? 100 : (max_order_auth + 100)


      dest_order = dest.destination_orders.build(trip_id: trip_id, order_authority: new_order_auth)
      dest_order.save!
    end
=end


  end


private

  #gets panoramia photos for the newly created destination at the specified size
  def getPanoramiaPhotos(destination, photo_size)
    debug = false

    puts 'getPanoramiaPhotos called!' if debug
    max_photos = 5.to_s

    destination_id = destination.id
    lat_min = (destination.lat - 0.05).to_s #minY
    lat_max = (destination.lat + 0.05).to_s #maxY

    lng_min = (destination.lng - 0.05).to_s #minX
    lng_max = (destination.lng + 0.05).to_s #maxX


    #first, call Panoramio
    response = HTTParty.get("http://www.panoramio.com/map/get_panoramas.php?set=public&from=0&to=" +
                            max_photos + "&minx=" + lng_min + "&miny=" + lat_min +
                            "&maxx=" + lng_max + "&maxy=" + lat_max + "&size=" + photo_size + "&mapfilter=true")

    puts response.to_yaml if debug

    response['photos'].each do |photo|
      puts 'photo title: ' + photo['photo_title'] if debug
      createPhotoFromPanoramioResponse(photo, destination_id, photo_size)
    end
  end

  #creates and saves the photo object from panoramia
  def createPhotoFromPanoramioResponse(photo_data, destination_id, size)
    debug = false

    puts photo_data.to_yaml if debug

    photo = DestinationPhoto.new
    photo.destination_id = destination_id
    photo.panoramio_photo_id = photo_data['photo_id']
    photo.height = photo_data['height']
    photo.width = photo_data['width']
    photo.lat = photo_data['latitude']
    photo.lng = photo_data['longitude']
    photo.photo_title = photo_data['photo_title']
    photo.photo_url = photo_data['photo_url']
    photo.photo_file_url = photo_data['photo_file_url']
    photo.photo_size = size
    photo.owner_url = photo_data['owner_url']
    photo.owner_name = photo_data['owner_name']
    photo.owner_id = photo_data['owner_id']

    photo.save
  end

  #returns a Destination object built with values from a Google place
  #PRE: Google place object should be parsed into ruby hash via JSON.parase
  def buildDestinationFromPlace(place)
    debug = false
    dest = Destination.new

    puts '************ YAML: ' + place.to_yaml if debug

    dest.name = place['name']
    dest.google_place_id = place['place_id']
    dest.formatted_address = place['formatted_address']

    #Google API Docs:
    #...the latitude coordinate is always written first, followed by the longitude
    #developers.google.com/maps/documentation/javascript/3.exp/reference#LatLng
    dest.lat = place['geometry']['location'].values[0]
    dest.lng = place['geometry']['location'].values[1]


    place['address_components'].each do |component|
      long_name = component['long_name']
      types = component['types']

      #for each type, look for that column in our db
      #if found, set it equal to long name
      types.each do |type|
        if Destination.column_names.include? type
          dest[type] = long_name

          #if type is country, also set iso 2 code for flags
          dest.country_iso_2 = component['short_name'] if type == 'country'
        end
      end #done with type iteration
    end #done with address componenet iteration

    puts '******** dest.valid: ' + (dest.valid?).to_s if debug

    return dest
  end
end
