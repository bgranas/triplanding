

$ ->

	$('.transportation-segments').hide()

	$('.body').on 'click', '.transportation-route-overview', ->
		if $(this).next('div').is(":visible")
			$('.transportation-segments').slideUp()
		else
			$('.transportation-segments').slideUp()
			$(this).next('div').slideToggle()

