#Put application-wide coffeescript here

$ ->

  ///user scrolled to top of page (test for map view)
  $(window).scroll (event) ->
    scroll = $(window).scrollTop()
    if scroll == 0
      alert 'user scrolled to top of page'
      map.setOptions({scrollwheel: false})
    return
  ///

  #preventing colorbox focus on load
  $(document).bind 'cbox_load', ->
    $('#colorbox').blur()


  #after colorbox completes, bind to sign-up form
  $(document).bind 'cbox_complete', ->
    #sign-up success or error actions
    $("#signup-form").on "ajax:success", (e, data, status, xhr) ->
      if data.success #signed-up
        window.location.replace(data.redirect)
      else #failed sign-up, but ajax call successful for some reason
        $('#signup-container').find('.error-message').html('')
        for error in data.errors
          do ->
            $('#signup-container').find('.error-message').append('<li>' + error + '</li>')
            $.colorbox.resize()

    #sign-up failed
    $("#signup-form").on "ajax:error", (e, xhr, status, error) ->
      $('#signup-container').find('.error-message').html('')
      data = JSON.parse(xhr.responseText)
      for e in data.errors
          do ->
            $('#signup-container').find('.error-message').append('<li>' + e + '</li>')
            $.colorbox.resize()



  #login success or error actions
  $("#login-form").on "ajax:success", (e, data, status, xhr) ->
    window.location.replace(data.redirect)
  $("#login-form").on "ajax:error", (e, xhr, status, error) ->
    $('#login-container').find('.error-message').text(xhr.responseText)




  $('.dropdown-toggle-hover').on('mouseover', ->
    $(this).find('.dropdown-menu').show()
    return
  ).on 'mouseout', (e) ->
    if !$(e.target).is('input')
      $(this).find('.dropdown-menu').hide()
    return

