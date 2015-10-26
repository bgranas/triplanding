#Put application-wide coffeescript here

$ ->

  $.colorbox.resize();

  #preventing colorbox focus on load
  $(document).bind 'cbox_load', ->
    $('#colorbox').blur()

  #resizing height on colorbox
  $(document).bind 'cbox_complete', ->
    $.colorbox.resize()

