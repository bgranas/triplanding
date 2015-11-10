

$ ->

	$('.transportation-segments').hide()

	$('.transportation-route-overview').click ->
		if $(this).next('div').is(":visible")
			$('.transportation-segments').slideUp()
		else
			$('.transportation-segments').slideUp()
			$(this).next('div').slideToggle()

