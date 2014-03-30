$(document).ready ->

	# prevents copy, cut, or right click on anything with class "protected"
	$('.protected').bind 'contextmenu copy cut', (e) ->
		e.preventDefault();
		return