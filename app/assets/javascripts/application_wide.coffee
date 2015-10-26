#Put application-wide coffeescript here

$ ->

  #preventing colorbox focus on load
  $(document).bind 'cbox_load', ->
    $('#colorbox').blur()

  $("#login-form").on "ajax:success", (e, data, status, xhr) ->
    alert "login success!"

  $("#login-form").on "ajax:error", (e, xhr, status, error) ->
    alert xhr.responseText

  $('.dropdown-toggle-hover').on('mouseover', ->
    $(this).find('.dropdown-menu').show()
    return
  ).on 'mouseout', (e) ->
    if !$(e.target).is('input')
      $(this).find('.dropdown-menu').hide()
    return

