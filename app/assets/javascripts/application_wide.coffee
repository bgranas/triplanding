#Put application-wide coffeescript here

$ ->

  #preventing colorbox focus on load
  $(document).bind 'cbox_load', ->
    $('#colorbox').blur()

  #login success or error actions
  $("#login-form").on "ajax:success", (e, data, status, xhr) ->
    location.reload()
  $("#login-form").on "ajax:error", (e, xhr, status, error) ->
    $('#login-container').find('.error-message').text(xhr.responseText)


  $('.dropdown-toggle-hover').on('mouseover', ->
    $(this).find('.dropdown-menu').show()
    return
  ).on 'mouseout', (e) ->
    if !$(e.target).is('input')
      $(this).find('.dropdown-menu').hide()
    return

