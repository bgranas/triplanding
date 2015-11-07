#anything code related to trips/new and trips/edit should be put here.

markers = []

$ ->


  $(document).bind 'cbox_complete', ->
    initSearch() #calling initSearch because initial call didn't bind to lightbox input

    # PRE: place should be defined from the autocomplete function
    # PRE: map should be initialized
    $('#add-destination-submit').click ->
      addPlacetoMap(place, map)


#adds a marker at the geolocation specified in place (google place),
#on the map specified in map
#returns the marker
addPlacetoMap = (place, map) ->
  marker = new google.maps.Marker
    position: place.geometry.location
    map: map
    title: place.formatted_address

  markers.push marker #add to the array of markers
  mCount = markers.length
  if mCount >= 2
    connectMarkers(markers[mCount-2], markers[mCount-1], map)

connectMarkers = (o_marker, d_marker, map) ->
  path_coordinates = [o_marker.position, d_marker.position]
  line_path = new google.maps.Polyline
    path: path_coordinates
    geodesic: true
    map: map
