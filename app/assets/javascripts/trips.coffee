# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


### ***********************************###
### *********** BINDINGS **************###
### ***********************************###

$ ->

  ### *********** MAP BINDINGS **************###

  #Bind 'Save' on map controls to saveTrip function
  $('#save-trip').click ->
    tripTitle = $('#trip_name_input').val()
    saveTrip(tripID, tripTitle)

  #Bind 'Remove' button on infowindow to removeDestination
  $('body').on 'click', '.remove-location', ->
    markerID = $(this).parent().data('marker-id')
    removeDestination(markerID, map)

  ### *********** SNAPSHOT BINDINGS **************###

  #Bind 'X' on snapshot to remove destination action
  $('body').on 'click', '.snapshot-close', ->
    markerID = $(this).parent().data('marker-id')
    removeDestination(markerID, map)

  #Bind clicking the snapshot to opening infowindow on map
  $('body').on 'click', '.snapshot-location-content', ->
    markerID = $(this).parent().data('marker-id')
    if typeof markerID != 'undefined'
      markerIndex = findMarkerIndexByID(markerID)
      openInfowindow(markerID, markerIndex)

  #Bind hover over the snapshot to show the drag and close buttons
  $('body').on 'mouseenter mouseleave', '.snapshot-location', ->
    dragIndicator = $(this).find('.snapshot-draggable-indicator')
    dragIndicator.toggleClass('hidden')
    $(this).find('.snapshot-close').toggleClass('hidden')

    #Bind hover over dragIndicator to popout snapshot
    dragIndicator.hover ->
      dragIndicator.parent().toggleClass('snapshot-location-shadow')

  ### *********** ITINERARY BINDINGS *************###
  $('.snapshot-toggle').click ->
    toggleTripSnapshot()

  $('#trip-snapshot-ul').sortable
    placeholder: 'snapshot-location-container-placeholder',
    items: "li:not(.not-sortable)"

  ### *********** LIGHTBOX BINDINGS **************###
  $(document).bind 'cbox_complete', ->
    initSearch() #calling initSearch because initial call didn't bind to lightbox input
    $('.add-destination-input').focus()

    # PRE: place should be defined from the autocomplete function
    # PRE: map should be initialized
    # Binds autocomplete and 'Add Destination' button
    $('#add-destination-submit').click ->
      if $('.add-destination-input').val() == ''
        $('.lightbox-warning').remove()
        content = $('.lightbox-warning-template').clone().removeClass('hidden')
        content.removeClass('.lightbox-warning-template').addClass('lightbox-warning')
        content.find('#lightbox-warning-content').html('Please enter a destination.')
        content.insertBefore('#add-destination-lightbox-wrapper')
        $.colorbox.resize()
      else
        setTimeout ->
          $('.lightbox-warning').remove()
          content = $('.lightbox-warning-template').clone().removeClass('hidden')
          content.removeClass('.lightbox-warning-template').addClass('lightbox-warning')
          content.insertBefore('#add-destination-lightbox-wrapper')
          $.colorbox.resize()
        , 300

  #Adding transportation paths


### ***********************************###
### ***** ADDING A DESTINATION ********###
### ***********************************###

markers = []
currentMarkerID = 0

#Generates unique marker ID for the page
generateMarkerID = ->
  return currentMarkerID++

#Parent function that should be called when a new destination is added to the map
# PRE: place should be defined from the autocomplete function
# PRE: map should be initialized
addDestination = (place, map) ->
  if place != null
    markerIndex = addMarkerToMap(place, map)
    response = saveDestinationToDatabase(place)
    destinationID = response.responseText
    addDestinationSnapshot(place, markerIndex, destinationID)


#Adds a marker at the geolocation specified in place (google place),
#on the map specified in map, connects path to previous marker if necessary
# PRE: Bounds array must be declared
# RET: Index of marker in markers array
addMarkerToMap = (place, map) ->
  markerID = generateMarkerID()
  marker = new google.maps.Marker
    position: place.geometry.location
    map: map
    title: place.formatted_address
    id: markerID

  #First, add new marker to the markers array
  markers.push marker
  markerIndex = markers.length-1 #marker index is last element or array

  #Binds click of marker to opening infowindow
  marker.addListener 'click', ->
    openInfowindowByID(markerID)

  #Extend maps bounds to show new marker
  bounds.extend marker.position

  polyline.getPath().setAt(markerIndex, marker.position);



  if markers.length == 1
    map.setCenter(marker.position)
    map.setOptions(zoom: 6)
  else
    map.fitBounds(bounds)

  #Lastly, open window of place just added
  openInfowindow(markerID, markerIndex)


  return markerID




#Saves the destination to the database if it doesn't already exist
# RET: destinationID of location
saveDestinationToDatabase = (place) ->
  $.ajax '/destinations',
    dataType: 'json'
    type: 'POST'
    data:
      place: JSON.stringify(place)
      trip_id: tripID
    success: (destinationID) ->
      return JSON.stringify(destinationID)
    failure: ->
      alert 'saveDestiantionToDatabase() Unsuccessful, please alert site admins'
      return

#Add destination to trip snapshot
addDestinationSnapshot = (place, markerID, destinationID) ->
  destinationName = place.name
  snapshot = $('#snapshot-location-template').clone(true).removeClass('hidden').removeAttr('id')
  #Setting data needed for trip
  snapshot.find('h5').text(place.name)
  snapshot.attr('data-marker-id', markerID)
  snapshot.attr('data-destination-id', destinationID)
  snapshot.attr('id', 'snapshot-location-' + markerID)
  snapshot.insertBefore('#snapshot-add-destination')

  $('#trip-snapshot-link-ul').append('<li></li>')

### ***********************************###
### ********** INFO WINDOW ************###
### ***********************************###

#Parent method to open Info Window for MarkerID
openInfowindow = (markerID, markerIndex) ->
  info_content = getInfowindowContent(markerID, markerIndex)
  infowindow.setContent(info_content)
  infowindow.open(map, markers[markerIndex])

#First finds the markerIndex then calls traditional method
openInfowindowByID = (markerID) ->
  markerIndex = findMarkerIndexByID(markerID)
  openInfowindow(markerID, markerIndex)

#@RET: Infowindow content (html) for destination markerID
getInfowindowContent = (markerID, markerIndex) ->
  iw = $('#infowindow-template').clone(true).removeClass('hidden').removeAttr('id')
  iw.find('h5').text(markers[markerIndex].title) #infowindow header
  iw.find('.infowindow-content').attr('data-marker-id', markerID)
  return  iw.html()

### ***********************************###
### ********** SAVE A TRIP ************###
### ***********************************###

#Save trip to database, destination and details should already be in the database
saveTrip = (trip_id, trip_title) ->
  $.ajax '/trips/create',
    dataType: 'json'
    type: 'POST'
    data:
      trip_title: trip_title
      trip_id: trip_id
    success: (data) ->
      alert 'Successful'
      return
    failure: ->
      alert 'Unsuccessful'
      return

### ***********************************###
### ***** REMOVE A DESTINATION ********###
### ***********************************###

#Remove destination parent function. Handles removing snapshot, marker, and itinerary
removeDestination = (markerID, map) ->
  removeSnapshot(markerID)
  removeMarker(markerID, map)


#Removes snapshot location associated to markerID
removeSnapshot = (markerID) ->
  $('#snapshot-location-' + markerID).remove()
  $('#trip-snapshot-link-ul li:first').remove()

#Removes a marker with markerIndex from the map and markers array
removeMarker = (markerID, map) ->
  markerIndex = findMarkerIndexByID(markerID)
  marker = markers[markerIndex]
  marker.setMap(null)
  polyline.getPath().removeAt(markerIndex)
  markers.splice(markerIndex, 1);

# RET: Returns the index of marker with the given ID
findMarkerIndexByID = (markerID) ->
  for marker, i in markers
    if marker.id == markerID
      return i


### ***********************************###
### ********* MISC FUNCTIONS **********###
### ***********************************###

autocomplete = null
place = null
#Autocomplete search box initialization
initSearch = ->
  autocomplete = new (google.maps.places.Autocomplete)(document.getElementById('location-query'), types: [ 'geocode' ])
  autocomplete.addListener 'place_changed', ->
    $('#lightbox-warning-template').hide()
    place = autocomplete.getPlace()
    addDestination(place, map)
    $.colorbox.close()

snapshotMinimized = true
mapClickListener = null
toggleTripSnapshot = ->
  if snapshotMinimized
    snapshotMinimized = false
    $('#itinerary').removeClass('hidden')
    $('#trip-snapshot-container').addClass('trip-snapshot-max')
    map.setOptions({draggableCursor:'s-resize'})
    $('.snapshot-toggle-icon').removeClass('fa-chevron-up').addClass('fa-chevron-down')
    mapClickListener = map.addListener 'click', ->
     toggleTripSnapshot()
  else
    snapshotMinimized = true
    map.setOptions({draggableCursor:null})
    $('#trip-snapshot-container').removeClass('trip-snapshot-max')
    $('.snapshot-toggle-icon').removeClass('fa-chevron-down').addClass('fa-chevron-up')
    google.maps.event.removeListener(mapClickListener)
    setTimeout ->
      $('#itinerary').addClass('hidden')
    , 500



