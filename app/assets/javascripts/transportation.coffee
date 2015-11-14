$ ->

  $('body').on 'click', '.transportation-route-overview', ->
    console.log("clicked")
    if $(this).next('div').is(":visible")
      $('.transportation-segments').slideUp()
    else
      $('.transportation-segments').slideUp()
      $(this).next('div').slideToggle()





