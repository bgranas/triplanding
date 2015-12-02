# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


### ***********************************###
### *********** BINDINGS **************###
### ***********************************###

window.saved = false

#only bind these to trips.new
$(".trips.new").ready ->

  ### *********** MAP BINDINGS **************###

  #Bind 'Save' on map controls to saveTrip function
  $('#save-trip').click ->
    tripTitle = $('#trip-title').text()
    saveTrip(tripID, tripTitle)

  #Bind 'Remove' button on infowindow to removeDestination
  $('body').on 'click', '.remove-location', ->
    markerID = $(this).parent().data('marker-id')
    removeDestination(markerID, map)

  #Dynamically resize input based off length
  $('body').on 'keyup', '#trip-title-input', ->
    $(this).attr({width: 'auto', size: $(this).val().length});

  #Bind 'Edit Title' icon to action
  $('body').on 'click', '#edit-title', ->
    $('#trip-title-confirmed').addClass('hidden')
    $('#trip-title-edit').removeClass('hidden')


  #Bind 'Confirm Title' icon to action
  $('body').on 'click', '#confirm-title', ->
    title = $('#trip-title-input').val()
    if title.length > 0 #there is a title
      $('#trip-title').text(title)
      $('#trip-title-confirmed').removeClass('hidden')
      $('#trip-title-edit').addClass('hidden')
    else #title is blank
      $('#trip-title-input').attr('placeholder', 'Title cannot be blank!')
      $('#trip-title-input').focus()

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


  window.curScroll = null
  $('body').on 'mouseleave', '#scroll-right', ->
    right_scroll_hovered = false
    clearInterval(scrollRight)
    window.curScroll = $('#trip-snapshot-ul').scrollLeft()

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
    #should close itinerary if maximized
    if snapshotMinimized == false
      toggleTripSnapshot()

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

  #Binds 'Add Departure City' link to show the autocomplete box
  $('body').on 'click', '#add-departure-link', ->
    initAutocompleteDeparture()

  #Binds 'Change Departure City' icon to show the autocomplete function
  $('body').on 'click', '#change-departure-city', ->
    hideDepartureContent()
    initAutocompleteDeparture()

  #Binds the 'X' next to the departure input to canceling the input
  $('body').on 'click', '#cancel-departure-city', ->
    showDepartureCityContent()

  #Binds 'remove' link in departure section of itinerary
  $('body').on 'click', '#remove-departure-city', ->
    removeDeparture()

  #Binds 'Add Return City' link to show the autocomplete box
  $('body').on 'click', '#add-return-link', ->
    initAutocompleteReturn()

  #Binds 'Change Return City' icon to show the autocomplete function
  $('body').on 'click', '#change-return-city', ->
    hideReturnCityContent()
    initAutocompleteReturn()

  #Binds 'remove' icon in return city section of itinerary
  $('body').on 'click', '#remove-return-city', ->
    removeReturnCity()

  #Binds the 'X' next to the return input to canceling the input
  $('body').on 'click', '#cancel-return-city', ->
    showReturnCityContent()

  #Binds the checkmark next to the departure city autocomplete to display an error if location not selected
  $('#confirm-departure-city').click ->
    setTimeout ->
      $('.lightbox-warning').remove()
      content = $('.lightbox-warning-template').clone().removeClass('hidden')
      content.removeClass('.lightbox-warning-template').addClass('lightbox-warning').addClass('inline-block')
      content.insertAfter('#departure-city-edit')
    ,

  #Binds the checkmark next to the return city autocomplete to display an error if location not selected
  $('#confirm-return-city').click ->
    setTimeout ->
      $('.lightbox-warning').remove()
      content = $('.lightbox-warning-template').clone().removeClass('hidden')
      content.removeClass('.lightbox-warning-template').addClass('lightbox-warning').addClass('inline-block')
      content.insertAfter('#return-city-edit')
    , 300


  $('#trip-snapshot-ul').sortable
    placeholder: 'snapshot-location-container-placeholder',
    items: "li:not(.not-sortable)",
    update: (event, ui) ->
      reorderDestination(ui)
    start: (event, ui) ->
      $('#trip-snapshot-ul').scrollLeft(window.curScroll) #preventing jump if scrolled all the way right
      ui.item.toggleClass('snap-hidden')
    stop: (event, ui) ->
      ui.item.toggleClass('snap-hidden')


  #Bind 'Add Transportation' in itinerary to trigger side popup
  $('body').on 'click', '.add-transportation', ->
    destinationRows = $('.destination-row')
    transportationRow = $(this).closest('.transportation-row')
    oIndex = destinationRows.index(transportationRow.prev())
    dIndex = destinationRows.index(transportationRow.next())
    console.log 'origin Index: ' + oIndex.toString()
    console.log 'destination Index: ' + dIndex.toString()
    getRoutes(oIndex, dIndex)


  #Bind 'X' in sidepopup to close popup
  $('body').on 'click', '#close-side-popup', ->
    $('#trip-snapshot-container').removeClass('trip-snapshot-min')
    hideSidePopup()


  ### *********** LIGHTBOX BINDINGS **************###
  $(document).bind 'cbox_complete', ->
    if isAddDestinationLightbox() #if it is the add destination lightbox
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
#FUTURE IMPROVEMENT - do this on map load, not on page load
$(".trips.new").ready ->
  $.colorbox({opacity: .5, href:"/blank/add_destination_helper"});

  ### *********** PAGE BINDINGS *************###
  $(window).bind 'beforeunload', ->
    if (window.saved == false) and markers.length > 0
      return 'You have unsaved changes to this trip!'

$(".trips.edit").ready ->
  ### *********** PAGE BINDINGS *************###
  $(window).bind 'beforeunload', ->
    if (window.saved == false) and markers.length > 0
      return 'You have unsaved changes to this trip!'

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

#returns true if there is a departure location added
isDepartureCity = ->
  if $('#departure-city').text().length == 0
    return false #no departure
  else
    return true #there is departure

#returns true if there is a return location added
isReturnCity = ->
  if $('#return-city').text().length == 0
    return false #no return city
  else
    return true #there is return city

#parent method to call when adding a departure city
addDepartureCity = (place) ->
  if place != null
    response = JSON.parse(saveDestinationToDatabase(place).responseText)
    destinationID = response.id

    addDepartureCityItinerary(place.formatted_address, destinationID)
    setUnsaved()

    #if there is no return city, match to the destination
    if not isReturnCity()
      addReturnCity(place)

#Adds the departure city to itinerary
#PARAMS: name of the departure city
addDepartureCityItinerary = (departure_name, destination_id) ->
  $('#departure-city').text(departure_name)
  $('#departure-city').attr('data-destination-id', destination_id)
  showDepartureCityContent()
  $('#remove-departure-city').removeClass('hidden')
  $('#change-departure-city').removeClass('hidden')
  $('#departure-row-transportation').removeClass('hidden')

#parent method to call when adding a departure city
addReturnCity = (place) ->
  if place != null
    response = JSON.parse(saveDestinationToDatabase(place).responseText)
    destinationID = response.id

    addReturnCityItinerary(place.formatted_address, destinationID)
    setUnsaved()

#Adds the departure city to itinerary
#PARAMS: name of the departure city
addReturnCityItinerary = (return_city_name, destination_id) ->
  $('#add-return-link').addClass('hidden')
  $('#return-city-edit').addClass('hidden')
  $('#return-city').attr('data-destination-id', destination_id)
  $('#return-city').text(return_city_name)
  showReturnCityContent()

  $('#return-row-transportation').removeClass('hidden')

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
    calculateTripMetrics() #update trip's metrics
    setUnsaved()


#Adds a marker at the geolocation specified in place (google place),
#on the map specified in map, connects path to previous marker if necessary
# PRE: Bounds array must be declared
# RET: Index of marker in markers array
# PARAM: insertIndex = index to insert marker into array and path
addMarkerToMap = (place, map, insertIndex) ->
  markerID = generateMarkerID()
  marker = new google.maps.Marker
    position: place.geometry.location
    title: place.formatted_address
    type: 'destination'
    id: markerID
    map: map

  #First, add new marker to the markers array
  markers.splice(insertIndex, 0, marker)

  #Binds click of marker to opening infowindow
  marker.addListener 'click', ->
    openInfowindowByID(markerID)

  #Extend maps bounds to show new marker
  window.bounds.extend marker.position

  polyline.getPath().insertAt(insertIndex, marker.position)

  #adjusting the map position with the new marker
  if markers.length == 1
    map.setCenter(marker.position)
    map.setOptions(zoom: 6)
  else
    map.fitBounds(window.bounds)

  #Lastly, open window of place just added
  openInfowindow(markerID, insertIndex)


  return markerID


#Saves the destination to the database if it doesn't already exist
# RET: destinationID of location
saveDestinationToDatabase = (place) ->
  place_lat = place.geometry.location.lat()
  place_lng = place.geometry.location.lng()
  $.ajax '/destinations',
    dataType: 'json'
    type: 'POST'
    async: false
    data:
      place:
        name: place.name
        place_id: place.place_id
        formatted_address: place.formatted_address
        address_components: place.address_components
        lat: place_lat
        lng: place_lng
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
    snapshot.find('.snapshot-location-content').css('background-image', 'url(' + bg_url + ')')
  else
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

  #finally, if a transport list is last, remove it -- THIS IS BAD DESIGN
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
  calculateTripMetrics() #update trip's metrics
  setUnsaved()


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

#Save trip to database for the destination orders defined in the snapshot
saveTrip = (trip_id, trip_title) ->
  destinationIDs = createDestinationArray()
  departure_city_id = $('#departure-city').attr('data-destination-id')
  return_city_id = $('#return-city').attr('data-destination-id')
  user_id = getCookie('current_user_id')
  if user_id #user is logged in
    $.ajax '/trips/create',
      dataType: 'json'
      type: 'POST'
      data:
        trip_title: trip_title
        trip_id: trip_id
        countries: countUniqueCountries()
        cities: countCities()
        distance: measureDistnace('Kilometers')
        destinationIDs: destinationIDs
        departure_city_id: departure_city_id
        return_city_id: return_city_id
        user_id: user_id
      success: (data) ->
        setSaved()
        return
      failure: ->
        return
  else #user is not logged in
    setCookie('pending_save_trip_id', trip_id, 10)
    $.colorbox {width:"380px", opacity: .5, href:"/blank/save_trip_sign_up_or_login_helper"}
    #lightbox prompt
    #after login, redirect to trips/show

#sets saved status to unsaved
setUnsaved = ->
  window.saved = false
  $('#save-status').removeClass('save-green').addClass('save-red').html('Unsaved')

#sets saved status to saved
setSaved = ->
  window.saved = true
  $('#save-status').removeClass('save-red').addClass('save-green').html('Saved')

#creates an array with the current order of the destinations for the trip
createDestinationArray = ->
  destinationIDs = []
  snapshots = $('#trip-snapshot-ul .snapshot-location')
  snapshots.each ->
    destinationIDs.push $(this).data('destination-id')
  return destinationIDs

### ***********************************###
### ***** REMOVE A DESTINATION ********###
### ***********************************###

#Remvove departure parent function
removeDeparture = ->
  removeDepartureItinerary()
  setUnsaved()

#Hide the departure city and icons, removes the transport row
removeDepartureItinerary = ->
  hideDepartureContent()
  $('#add-departure-link').removeClass('hidden')
  $('#departure-city').attr('data-destination-id', '')
  $('#departure-row-transportation').addClass('hidden')
  $('#departure-city').text('')

#Hides the departure city name, edit, and delete icons
hideDepartureContent = ->
  $('#departure-city').addClass('hidden')
  $('#remove-departure-city').addClass('hidden')
  $('#change-departure-city').addClass('hidden')

#Hides the departure edit section
#Shows the departure city name, edit, and delete icons
showDepartureCityContent = ->
  $('#departure-city-edit').addClass('hidden')

  #If there is a departure city chosen, show that
  if isDepartureCity()
    $('#departure-city').removeClass('hidden')
    $('#remove-departure-city').removeClass('hidden')
    $('#change-departure-city').removeClass('hidden')
  else
    removeDepartureItinerary()

#Remvove return parent function
removeReturnCity = ->
  removeReturnCityItinerary()
  setUnsaved()

#Hide the return city and icons, removes the transport row
removeReturnCityItinerary = ->
  hideReturnCityContent()
  $('#add-return-link').removeClass('hidden')
  $('#return-city').attr('data-destination-id', '')
  $('#return-row-transportation').addClass('hidden')
  $('#return-city').text('')

#Hides the return city name, edit, and delete icons
hideReturnCityContent = ->
  $('#return-city').addClass('hidden')
  $('#remove-return-city').addClass('hidden')
  $('#change-return-city').addClass('hidden')

#Hides the return edit section
#Shows the return city name, edit, and delete icons
showReturnCityContent = ->
  $('#return-city-edit').addClass('hidden')

  #If there is a return city chosen, show that
  if isReturnCity()
    $('#return-city').removeClass('hidden')
    $('#remove-return-city').removeClass('hidden')
    $('#change-return-city').removeClass('hidden')
  else
    removeReturnCityItinerary()

#Remove destination parent function. Handles removing snapshot, marker, and itinerary
removeDestination = (markerID, map) ->
  removeSnapshot(markerID)
  removeMarker(markerID, map)
  removeItinerary(markerID)
  calculateTripMetrics() #update trip's metrics
  setUnsaved()


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
  redoBounds()

#Redoes the bounds of the map based off the current markers array
redoBounds = ->
  if markers.length == 1
    map.setCenter(markers[0].position)
    map.setOptions(zoom: 6)
  else if markers.length > 1
    window.bounds = new google.maps.LatLngBounds()
    for marker in markers
      window.bounds.extend marker.position

    map.fitBounds(window.bounds)


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

#returns true if visible lightbox is to add destination, else false
isAddDestinationLightbox = ->
  if document.getElementById('add-destination-lightbox-wrapper')
    return true
  else
    return false

#Calculates the trip's metrics (countries, cities, and KM)
#PRE: polyline must equal the current polyline of the map
calculateTripMetrics = ->
  distance = measureDistnace('kilometers')
  cities = countCities()
  countries = countUniqueCountries()

  $('#trip-metrics-cities strong').text(cities)
  $('#trip-metrics-countries strong').text(countries)
  $('#trip-metrics-distance strong').text(distance)

  #fixing GRAMMERZ
  if cities == 1
    $('#trip-metrics-cities span').text(' City')
  else
    $('#trip-metrics-cities span').text(' Cities')

  if countries == 1
    $('#trip-metrics-countries span').text(' Country')
  else
    $('#trip-metrics-countries span').text(' Countries')


  $('#trip-metrics strong').digits() #format numbers with commas

#RET: returns the distance of a trips polyline in the unit specified in the parameters
#If the unit specified is unrecognized, returns distance of polyline in KM
measureDistnace = (unit) ->
  lengthInMeters = google.maps.geometry.spherical.computeLength(polyline.getPath())
  if unit == 'miles'
    return Math.round(lengthInMeters/1609.34)
  else if unit == 'meters'
    return Math.round(lengthInMeters)
  else #return Kilometers
    return Math.round(lengthInMeters/1000)

#RET: returns the number of  cities in a trip
countCities = ->
  return  $('#itinerary-transportation-destination-ul .destination-row').length

#RET: returns the number of unique countires in this destination
#Countriescounts are based off the destination rows country column, so
#if html changes there, this method may break :/
countUniqueCountries = ->
  uniqueCountries = {}
  $('#itinerary-transportation-destination-ul .destination-row .itinerary-step-country').each ->
    uniqueCountries["'" + $(this).text() + "'"] = 1
  return Object.keys(uniqueCountries).length

#Shows the sidepopup
showSidePopup = ->
  $('#side-popup').css('width', '50%')
  $('#side-popup .container-fluid').removeClass('hidden')

#Hides the sidepopup
hideSidePopup = ->
  $('#side-popup').css('width', '0px')
  $('#add-transport-box').html('')
  $('#side-popup .container-fluid').addClass('hidden')

  #lastly, delete those routes
  for polyline in  polylines
      polyline.setOptions({map: null})

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

place = null
#Autocomplete search box initialization for adding destination
initSearch = ->
  autocomplete = new (google.maps.places.Autocomplete)(document.getElementById('location-query'), types: [ 'geocode' ])
  autocomplete.bindTo('bounds', map)
  autocomplete.addListener 'place_changed', ->
    place = autocomplete.getPlace()

    addDestination(place, map, insertIndex)
    $.colorbox.close()

    #setting bounds around new place
    biasCircle = new google.maps.Circle
      center: place.geometry.location
      radius: 500 #in kilometers
    autocomplete.setBounds(biasCircle.getBounds())

#initializing autocomplete for departure
initAutocompleteDeparture = ->
  #Unhide input fields
  $('#departure-city-input').val('')
  $('#add-departure-link').addClass('hidden')
  $('#departure-city-edit').removeClass('hidden')
  $('#departure-city-input').focus()

  #Setup autocomplete
  autocomplete = new (google.maps.places.Autocomplete)(document.getElementById('departure-city-input'), types: [ 'geocode' ])
  autocomplete.addListener 'place_changed', ->
    #Hide any warnings
    $('.lightbox-warning-template').addClass('hidden')
    place = autocomplete.getPlace()
    addDepartureCity(place)

#initializing autocomplete for return city input
initAutocompleteReturn = ->
  #Unhide input fields
  $('#return-city-input').val('')
  $('#add-return-link').addClass('hidden')
  $('#return-city-edit').removeClass('hidden')
  $('#return-city-input').focus()

  #Setup autocomplete
  autocomplete = new (google.maps.places.Autocomplete)(document.getElementById('return-city-input'), types: [ 'geocode' ])
  autocomplete.addListener 'place_changed', ->
    $('.lightbox-warning-template').addClass('hidden')
    place = autocomplete.getPlace()
    addReturnCity(place)


snapshotMinimized = true
mapClickListener = null
toggleTripSnapshot = ->
  if snapshotMinimized
    snapshotMinimized = false
    $('#itinerary').removeClass('hidden')
    $('#trip-snapshot-container').removeClass('trip-snapshot-min').addClass('trip-snapshot-max')
    map.setOptions({draggableCursor:'s-resize'})
    $('.snapshot-toggle-icon').removeClass('fa-chevron-up').addClass('fa-chevron-down')
    mapClickListener = map.addListener 'click', ->
     toggleTripSnapshot()
  else
    minimizeItinerary()

minimizeItinerary = ->
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

#parent method to trigger R2R call and display routes form dest to dest
getRoutes = (oIndex, dIndex) ->
  $('#trip-snapshot-container').addClass('trip-snapshot-min')
  minimizeItinerary()

  oLat = markers[oIndex].getPosition().lat()
  oLng = markers[oIndex].getPosition().lng()
  dLat = markers[dIndex].getPosition().lat()
  dLng = markers[dIndex].getPosition().lng()
  passRouteToTransportation(oLat, oLng, dLat, dLng)
  showSidePopup()

passRouteToTransportation = (oLat, oLng, dLat, dLng) ->
  oPos = oLat + ',' + oLng
  dPos = dLat + ',' + dLng
  $.ajax '/segments/r2r_call',
    type: 'POST'
    async: true
    data:
      oPos: oPos
      dPos: dPos
    success: (data) ->
      $('#add-transport-box').html(data)

      #Hiding individual segment results in transport results
      $('.transportation-segments').hide()
      showAllTransportPaths()
    failure: ->
      alert 'passDestinationToTransportation Unsuccessful, please alert site admins'
      return



### ***********************************###
### *** ADDING TRANSPORTATION PATHS ***###
### ***********************************###

showAllTransportPaths = ->
  flightCount=0
  console.log 'routePaths.length' + routePaths.length
  for routePath in routePaths
    for segmentPath in routePath
      if segmentPath.length == 0
        #build google latlng literal
        source_geo = {lat: Number(airportPathsLat[flightCount][0]), lng: Number(airportPathsLng[flightCount][0])}
        target_geo = {lat: Number(airportPathsLat[flightCount][1]), lng: Number(airportPathsLng[flightCount][1])}
        path = [source_geo, target_geo]
        setTransportPath(map, path ,false)
        flightCount = flightCount + 1
      else
        setTransportPath(map, segmentPath, true)


polylines = []
unhighlightedSegmentColor = "#d9d9d9"
highlightedSegmentColor = "#434D98"
setTransportPath =  (map, path, needDecode) ->
  if needDecode
    transportPath = google.maps.geometry.encoding.decodePath(path)
  else
    transportPath = path

  polyline = new google.maps.Polyline
    map: map
    geodesic: true
    path: transportPath
    strokeColor: unhighlightedSegmentColor
    strokeWeight: 5

  polylines.push polyline


#****HIHGLIGHTING PATHS WHEN ROUTE SELECTED****#

highlightSelectedSegmentPath = (index) ->
  polylines[index].setOptions({strokeColor: highlightedSegmentColor})

unhighlightSelectedSegmentPath = (index) ->
  polylines[index].setOptions({strokeColor: unhighlightedSegmentColor; strokeOpacity: .2})

$ ->

  $('body').on 'click', '.transportation-route-overview', ->
    for polyline in  polylines
      polyline.setOptions({strokeColor: unhighlightedSegmentColor})

    if $(this).parent().find('.transportation-segments').is(":visible")
      $('.transportation-segments').slideUp()
      $(this).find('.route-segment-overview').each ->
        segmentID = $(this).data('segment-id')
        unhighlightSelectedSegmentPath(segmentID)
    else
      $('.transportation-segments').slideUp()
      $(this).parent().find('.transportation-segments').slideToggle()
      $(this).find('.route-segment-overview').each ->
        segmentID = $(this).data('segment-id')
        highlightSelectedSegmentPath(segmentID)
