class DestinationsController < ApplicationController


  def create
    place = JSON.parse params[:place]

    #use destination if already in the DB, otherwise create a new one
    dest = Destination.find_by_google_place_id(place['id'])
    if dest.nil?
      dest = buildDestinationFromPlace(place)
      dest.save
    end


    if dest.persisted?
      render :json => {id: dest.id, country: dest.country, country_code: dest.country_iso_2}
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
  #returns a Destination object built with values from a Google place
  #PRE: Google place object should be parsed into ruby hash via JSON.parase
  def buildDestinationFromPlace(place)
    debug = false
    dest = Destination.new

    puts '************ YAML: ' + place.to_yaml if debug

    dest.name = place['name']
    dest.google_place_id = place['id']
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
