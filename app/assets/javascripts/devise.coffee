#Put coffeescript related to devise contollers here


$(".registrations.new").ready ->
  $("#signup-form").on "ajax:success", (e, data, status, xhr) ->
      if data.success #signed-up
        window.location.replace(data.redirect)
      else #failed sign-up, but ajax call successful for some reason
        $('#signup-container').find('.error-message').html('')
        for error in data.errors
          do ->
            $('#signup-container').find('.error-message').append('<li>' + error + '</li>')
            $('#signup-container').find('.error-message').fadeIn().removeClass('hidden')
            $.colorbox.resize()

    #sign-up failed
    $("#signup-form").on "ajax:error", (e, xhr, status, error) ->
      $('#signup-container').find('.error-message').html('')
      data = JSON.parse(xhr.responseText)
      alert 'failed - # of errors: ' + data.errors.length
      console.log 'failed - data: ' + data.toString()
      for e in data.errors
          do ->
            $('#signup-container').find('.error-message').append('<li>' + e + '</li>')
            $('#signup-container').find('.error-message').fadeIn().removeClass('hidden')
            $.colorbox.resize()

