

$ ->

	$('.transportation-segments-all').hide()

	$('.transportation-show li a').click ->
		if $(this).parent().next('ul').is(":visible")
			$('.transportation-segments-all').slideUp()
		else
			$('.transportation-segments-all').slideUp()
			$(this).parent().next('ul').slideToggle()


