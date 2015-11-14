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

  #Add destination links should close the itinerary if maximized
  $('.add-destination-link').click ->
    if snapshotMinimized == false
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
    markerID = addMarkerToMap(place, map)
    response = JSON.parse(saveDestinationToDatabase(place).responseText)
    destinationID = response.id
    destinationCountry = response.country
    destinationCountryCode = response.country_code


    addDestinationSnapshot(place, markerID, destinationID)
    addDestinationItinerary(place, markerID, destinationCountry, destinationCountryCode)


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
    async: false
    data:
      place: JSON.stringify(place)
      trip_id: tripID
    success: (data) ->
      return data
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

#Add destination to trip itinerary
addDestinationItinerary = (place, markerID, country, country_code) ->
  #if add-destination row is visible, hide it
  if !$('#add-destination-row').hasClass('hidden')
    $('#add-destination-row').addClass('hidden')

  destinationRow = $('#destination-row-template').clone(true).removeClass('hidden').removeAttr('id')

  #+1 because I haven't added myself yet
  destinationCount = $('#itinerary-transportation-destination-ul .destination-row').length + 1

  #Setting the destination row values
  destinationRow.find('.itinerary-step-city').text(place.name)
  destinationRow.find('.itinerary-step-country').text(country)
  destinationRow.find('.calendar-text').text(destinationCount)
  #add flag icon later with country_code
  destinationRow.attr('data-marker-id', markerID)
  destinationRow.attr('id', 'destination-location-' + markerID)

  if destinationCount > 1 #if you're not the first destination, add transportation link
    transportationRow = $('#transportation-row-template').clone(true).removeClass('hidden').removeAttr('id')
    $('#itinerary-transportation-destination-ul').append(transportationRow)

  $('#itinerary-transportation-destination-ul').append(destinationRow)


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
  removeItinerary(markerID)


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

#Removes a destination row from the itinerary
removeItinerary = (markerID) ->
  destinationRow = $('#destination-location-' + markerID)
  destinationCount = $('#itinerary-transportation-destination-ul .destination-row').length
  destinationIndex = $('#itinerary-transportation-destination-ul .destination-row').index(destinationRow)

  if destinationCount == 1 #if only destination, add back in the add dest button
    $('#add-destination-row').removeClass('hidden')
  else if (destinationIndex+1) != destinationCount #if I'm not last, remove transport link after me
    destinationRow.next().remove()
  else #i'm last, remove transportation link before me
    destinationRow.prev().remove()

  #lastly, remove myself
  destinationRow.remove()

  reorderItineraryCalendars()


#Redoes the numbers inside the itinerary calendars on each destination row
reorderItineraryCalendars = ->
  destinations = $('#itinerary-transportation-destination-ul .destination-row')
  destinations.each (i, dest) ->
    $(dest).find('.calendar-text').text(i+1)


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


### ***********************************###
### *** PASSING DEST TO TRANSPORTATION ###
### ***********************************###
#oPos = "31.626710,-7.994810"
#dPos = "-33.917524,18.423252"

$ ->
  $('#add-transport-test').click ->
    passRouteToTransportation()
    

passRouteToTransportation = ->
  $.ajax '/routes/r2r_call',
    type: 'POST'
    async: true
    data:
      oPos: "31.626710,-7.994810"
      dPos: "-33.917524,18.423252"
    success: (data) ->
      $('#add-transport-box').html(data)

      #Hiding individual segment results in transport results
      $('.transportation-segments').hide()
    failure: ->
      alert 'passDestinationToTransportation Unsuccessful, please alert site admins'
      return



### ***********************************###
### *** ADDING TRANSPORTATION PATHS ***###
### ***********************************###


#Finds index of route by ID in order to get that route's transport path
###
findRouteIndex = (routeID) ->
  routeRow = $('#' + routeID)
  routeRowCount = $('.col-xs-9 transportation-route-detailbar').length
  console.log(routeRowCount)
  routeRowIndex = $('.col-xs-9 transportaiton-route-detailbar').index(routeRow)


$ ->
  
  $('body').on 'click', '.transportation-route-detailbar', ->
    index = findRouteIndex(this.id)
    #console.log(index)
    flightCount=0
    airportPathsLat = gon.watch(airportPathsLat)
    console.log("airport paths lat: ") + airportPathsLat
    airportPathsLng = gon.watch(airportPathsLng)
    #console.log("airport routes" + airportRoutes)
    for routePath in gon.watch(routePaths)#[index]
      for segmentPath in routePath
        if segmentPath.length == 0
          #build google latlng literal
          #console.log JSON.stringify(airportPathsLat[0])
          source_geo = {lat: Number(airportPathsLat[flightCount][0]), lng: Number(airportPathsLng[flightCount][0])}
          console.log "source_geo: " + JSON.stringify(source_geo) 
          target_geo = {lat: Number(airportPathsLat[flightCount][1]), lng: Number(airportPathsLng[flightCount][1])}
          console.log 'target_geo: ' + JSON.stringify(target_geo)  
          path = [source_geo, target_geo]
          setTransportPath(map, path ,false)
          flightCount = flightCount + 1
        else
          setTransportPath(map, segmentPath, true)


setTransportPath =  (map, path, needDecode) ->
    if needDecode
      transportPath = google.maps.geometry.encoding.decodePath(path)
      #console.log("route path" + transportPath)
    else
      transportPath = path
      console.log("airport path" + JSON.stringify(transportPath))    
    
    routePath = new google.maps.Polyline
      map: map
      path: transportPath
      strokeColor: '#767f93'
      strokeWeight: 2
      routeID: 43
###



