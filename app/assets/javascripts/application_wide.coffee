#Put application-wide coffeescript here

$ ->

  #preventing colorbox focus on load
  $(document).bind 'cbox_load', ->
    $('#colorbox').blur()


  #after colorbox completes, bind to sign-up form
  $(document).bind 'cbox_complete', ->
    #sign-up success or error actions
    $("#signup-form").on "ajax:success", (e, data, status, xhr) ->
      alert 'ajax successful'
      if data.success #signed-up
        #location.reload()
      else #failed sign-up
        $('#signup-container').find('.error-message').html('')
        alert 'data.success = failed. errors: ' + data.errors
        for error in data.errors
          do ->
            $('#signup-container').find('.error-message').append('<li>' + error + '</li>')
            $.colorbox.resize()


      #location.reload()
    $("#signup-form").on "ajax:error", (e, xhr, status, error) ->
      $('#signup-container').find('.error-message').html('')
      data = JSON.parse(xhr.responseText)
      for e in data.errors
          do ->
            $('#signup-container').find('.error-message').append('<li>' + e + '</li>')
            $.colorbox.resize()



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

