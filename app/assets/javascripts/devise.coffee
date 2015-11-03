#Put coffeescript related to devise contollers here

$ ->

  $(".registrations.new").ready ->
    #sign-up success or error actions
    $("#signup-form").on "ajax:success", (e, data, status, xhr) ->
      alert 'ajax success'

      if data.success #signed-up
        window.location.replace(data.redirect)
      else #failed sign-up, but ajax call successful for some reason
        $('#signup-container').find('.error-message').html('')
        for error in data.errors
          do ->
            $('#signup-container').find('.error-message').append('<li>' + error + '</li>')
            $('#signup-container').find('.error-message').fadeIn().removeClass('hidden')

    #sign-up failed
    $("#signup-form").on "ajax:error", (e, xhr, status, error) ->
      $('#signup-container').find('.error-message').html('')
      data = JSON.parse(xhr.responseText)
      for e in data.errors
          do ->
            $('#signup-container').find('.error-message').append('<li>' + e + '</li>')
            $('#signup-container').find('.error-message').fadeIn().removeClass('hidden')

