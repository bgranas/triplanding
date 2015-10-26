#Put application-wide coffeescript here

$ ->
  #preventing colorbox focus on load
  $(document).bind 'cbox_load', ->
    $('#colorbox').blur()

