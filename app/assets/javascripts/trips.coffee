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

  #Bind hover of snapshot-ul to show scroll arrows if overflowing
  $('body').on 'mouseenter', '#trip-snapshot-ul, .snapshot-scroll', ->
    if snapshotOverflow()
      $('.snapshot-scroll').removeClass('hidden')
    else
      $('.snapshot-scroll').addClass('hidden')

  $('body').on 'mouseleave', '.snapshot-scroll, #trip-snapshot-ul', ->
    if not $('.snapshot-scroll').hasClass('hidden')
      $('.snapshot-scroll').addClass('hidden')

  right_scroll_hovered = false
  scrollRight = null
  #scroll right on snapshot arrow hover
  $('body').on 'mouseenter', '#scroll-right', ->
    right_scroll_hovered = true
    scrollRight = setInterval ->
      if right_scroll_hovered
        x = $('#trip-snapshot-ul').scrollLeft();
        $('#trip-snapshot-ul').scrollLeft(x+2);
    ,5

  $('body').on 'mouseleave', '#scroll-right', ->
    right_scroll_hovered = false
    clearInterval(scrollRight)

  left_scroll_hovered = false
  scrollLeft = null
  #scroll right on snapshot arrow hover
  $('body').on 'mouseenter', '#scroll-left', ->
    left_scroll_hovered = true
    #console.log 'hover on! left_scroll_hovered: ' + left_scroll_hovered
    scrollLeft = setInterval ->
      if left_scroll_hovered
        x = $('#trip-snapshot-ul').scrollLeft();
        $('#trip-snapshot-ul').scrollLeft(x-2);
    ,5

  $('body').on 'mouseleave', '#scroll-left', ->
    left_scroll_hovered = false
    clearInterval(scrollLeft)

    #console.log 'hover off! left_scroll_hovered: ' + left_scroll_hovered


  #Bind '+' (add destination) on snapshot and itinerary to set the insertIndex for the marker
  $('body').on 'click', '.add-destination-link', ->
    #adding destination to the end of the list, so index will be last marker
    setInsertIndex(markers.length)


  #Bind 'Add Destination' on infowindow to set insertIndex correctly
  $('body').on 'click', '.infowindow-add-destination', ->
    markerID = $(this).parent().data('marker-id')
    markerIndex = findMarkerIndexByID(markerID)
    setInsertIndex(markerIndex + 1) #insert after this marker

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
    items: "li:not(.not-sortable)",
    update: (event, ui) ->
      reorderDestination(ui)
    start: (event, ui) ->
      ui.item.toggleClass('snap-hidden')
    stop: (event, ui) ->
      ui.item.toggleClass('snap-hidden')

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


    #HACK - should simulate click on page load
    #FUTURE FIX - only trigger lightbox if no destination has been added from landing page
$ ->
  $.colorbox({opacity: .5, href:"/blank/add_destination_helper"});

### ***********************************###
### ***** ADDING A DESTINATION ********###
### ***********************************###

markers = []
currentMarkerID = 0
insertIndex = 0

#set's insertIndex variable to parameter
#can't set global variables in bind function, apparently
# ^fuck you javascript
setInsertIndex = (i) ->
  insertIndex = i

#Generates unique marker ID for the page
generateMarkerID = ->
  return currentMarkerID++

#Parent function that should be called when a new destination is added to the map
# PRE: place should be defined from the autocomplete function
# PRE: map should be initialized
# PARAM: insertIndex - index to insert the new marker into markers[] and path[]
addDestination = (place, map, insertIndex) ->
  if place != null
    markerID = addMarkerToMap(place, map, insertIndex)
    response = JSON.parse(saveDestinationToDatabase(place).responseText)
    destinationID = response.id
    destinationCountry = response.country
    destinationCountryCode = response.country_code
    bg_url = response.thumbnail_url

    addDestinationSnapshot(place, markerID, destinationID, insertIndex, bg_url)
    addDestinationItinerary(place, markerID, destinationCountry, destinationCountryCode, insertIndex)




#Adds a marker at the geolocation specified in place (google place),
#on the map specified in map, connects path to previous marker if necessary
# PRE: Bounds array must be declared
# RET: Index of marker in markers array
# PARAM: insertIndex = index to insert marker into array and path
addMarkerToMap = (place, map, insertIndex) ->
  markerID = generateMarkerID()
  marker = new google.maps.Marker
    position: place.geometry.location
    map: map
    title: place.formatted_address
    id: markerID

  #First, add new marker to the markers array
  markers.splice(insertIndex, 0, marker)

  #Binds click of marker to opening infowindow
  marker.addListener 'click', ->
    openInfowindowByID(markerID)

  #Extend maps bounds to show new marker
  bounds.extend marker.position

  polyline.getPath().insertAt(insertIndex, marker.position)



  if markers.length == 1
    map.setCenter(marker.position)
    map.setOptions(zoom: 6)
  else
    map.fitBounds(bounds)

  #Lastly, open window of place just added
  openInfowindow(markerID, insertIndex)


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
addDestinationSnapshot = (place, markerID, destinationID, insertIndex, bg_url) ->
  destinationName = place.name
  snapshot = $('#snapshot-location-template').clone(true).removeClass('hidden').removeAttr('id')
  #Setting data needed for trip
  snapshot.find('h5').text(shorten(place.name, 20))
  snapshot.attr('data-marker-id', markerID)
  snapshot.attr('data-destination-id', destinationID)
  snapshot.attr('id', 'snapshot-location-' + markerID)
  if not (bg_url == null || bg_url == undefined)
    console.log 'bg_url defined!'
    snapshot.find('.snapshot-location-content').css('background-image', 'url(' + bg_url + ')')
  else
    console.log 'bg_url undefined!'
    snapshot.find('.transparent-layer').css('background-color', 'rgba(0, 0, 0, 0.3)')

  destinationCount = $('#trip-snapshot-ul .snapshot-location').length

  if destinationCount == 0 # first destination, add to beginning of list
    snapshot.insertBefore('#snapshot-add-destination')
  else
    snapshot.insertAfter('#trip-snapshot-ul .snapshot-location:nth-child(' + insertIndex + ')')


#Add destination to trip itinerary
addDestinationItinerary = (place, markerID, country, country_code, insertIndex) ->
  #if add-destination row is visible, hide it
  if !$('#add-destination-row').hasClass('hidden')
    $('#add-destination-row').addClass('hidden')

  destinationRow = $('#destination-row-template').clone(true).removeClass('hidden').removeAttr('id')

  #Setting the destination row values
  destinationRow.find('.itinerary-step-city').text(place.name)
  destinationRow.find('.itinerary-step-country').text(country)
  destinationRow.find('.calendar-text').text(insertIndex + 1)
  #add flag icon later with country_code
  destinationRow.attr('data-marker-id', markerID)
  destinationRow.attr('id', 'destination-location-' + markerID)

  insertDestinationRow(destinationRow, insertIndex, 0)


#inserts Destination Row at insertIndex
insertDestinationRow = (destinationRow, insertIndex, oldIndex) ->
  destinationCount = $('#itinerary-transportation-destination-ul .destination-row').length
  if destinationCount == 0 #if I'm first, just add myself
    $('#itinerary-transportation-destination-ul').append(destinationRow)
  else
    transportationRow = $('#transportation-row-template').clone(true).removeClass('hidden').removeAttr('id')
    $('#itinerary-transportation-destination-ul .destination-row').eq(insertIndex-1).after(transportationRow)
    destinationRow.insertAfter(transportationRow)
    reorderItineraryCalendars()

  #finally, if a transport list is last, remove it THIS IS BAD DESIGN
  last_itinerary_row = $('#itinerary-transportation-destination-ul .row').last()
  if last_itinerary_row.hasClass('transportation-row')
    last_itinerary_row.remove()

### ***********************************###
### ******* REORDER DESINATION ********###
### ***********************************###
reorderDestination = (ui) ->
  snapshot = ui.item
  markerID = snapshot.data('marker-id')
  oldIndex = findMarkerIndexByID(markerID)
  newIndex = $('#trip-snapshot-ul .snapshot-location').index(snapshot)

  #Algorithm: delete first, then reinsert at newIndex
  temp_marker = markers[oldIndex]
  markers.splice(oldIndex,1)
  markers.splice(newIndex,0, temp_marker)

  temp_path = polyline.getPath().getAt(oldIndex)
  polyline.getPath().removeAt(oldIndex)
  polyline.getPath().insertAt(newIndex, temp_path)

  reorderItinerary(markerID, oldIndex, newIndex)


#moves the destination associated with markerID from oldIndex to newIndex
reorderItinerary = (markerID, oldIndex, newIndex) ->
   temp_itinerary_destination = $('#destination-location-' + markerID).clone(true)

   #Algorithm: remove my transportation, remove me, add me, add transportation
   $('#destination-location-' + markerID).next().remove()
   $('#destination-location-' + markerID).remove()

   insertDestinationRow(temp_itinerary_destination, newIndex, oldIndex)


#print names of each marker in order
#for debugging
printMarkers = ->
  console.log 'Printing markers:'
  for mark in markers
    console.log '--' + mark.title

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


#return true if snapshot is overflowing, else false
#this will allow the scroll arrows to display on hover
snapshotOverflow = ->
   if $("#trip-snapshot-ul").prop('scrollWidth') > $('#trip-snapshot-ul').width()
      return true
    else
      return false

#cuts text off at max_length and replaces with '...'
shorten = (text, max_length) ->
  ret = text
  if ret.length > max_length
      ret = ret.substr(0,max_length) + "...";

  return ret

autocomplete = null
place = null
#Autocomplete search box initialization
initSearch = ->
  autocomplete = new (google.maps.places.Autocomplete)(document.getElementById('location-query'), types: [ 'geocode' ])
  autocomplete.addListener 'place_changed', ->
    $('#lightbox-warning-template').hide()
    place = autocomplete.getPlace()
    addDestination(place, map, insertIndex)
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
### *** ADDING TRANSPORTATION PATHS ***###
### ***********************************###

$ ->
  $('.transportation-routes').click ->
    flightCount=0
    airportPathsLat = gon.airportPathsLat
    airportPathsLng = gon.airportPathsLng
    #console.log("airport routes" + airportRoutes)
    for routePath in gon.routePaths
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




