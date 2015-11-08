#anything code related to trips/new and trips/edit should be put here.

markers = []

$ ->


  $(document).bind 'cbox_complete', ->
    initSearch() #calling initSearch because initial call didn't bind to lightbox input

    # PRE: place should be defined from the autocomplete function
    # PRE: map should be initialized
    $('#add-destination-submit').click ->
      addPlaceToMap(place, map)
      saveDestinationToDatabase(place)


#adds a marker at the geolocation specified in place (google place),
#on the map specified in map
#PRE: bounds array must be declared
addPlaceToMap = (place, map) ->
  marker = new google.maps.Marker
    position: place.geometry.location
    map: map
    title: place.formatted_address

  #add position to the maps bounds
  bounds.extend marker.position

  #connect the new marker with the last marker if needed
  markers.push marker #add to the array of markers
  mCount = markers.length
  if mCount == 1
    map.setCenter(marker.position)
    map.setOptions(zoom: 6)
  else if mCount >= 2
    connectMarkers(markers[mCount-2], markers[mCount-1], map)
    map.fitBounds(bounds)

connectMarkers = (o_marker, d_marker, map) ->
  path_coordinates = [o_marker.position, d_marker.position]
  line_path = new google.maps.Polyline
    path: path_coordinates
    geodesic: true
    map: map

saveDestinationToDatabase = (place) ->
  $.ajax '/destinations',
    dataType: 'json'
    type: 'POST'
    data:
      place: JSON.stringify(place)
      trip_id: tripID
    success: (data) ->
      alert 'Successful'
      return
    failure: ->
      alert 'Unsuccessful'
      return
