# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


snapshotMinimized = true
mapClickListener = null


$ -> #on document ready


  $('.snapshot-location-container').hover ->
    $(this).find('.snapshot-location-controls').toggleClass('hidden')

  $('.snapshot-toggle').click ->
    toggleTripSnapshot()


toggleTripSnapshot = ->
  if snapshotMinimized
    snapshotMinimized = false
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
