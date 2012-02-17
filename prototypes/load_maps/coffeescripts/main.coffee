$ ->
	myOptions =
		center: new google.maps.LatLng(-34.397, 150.644)
		zoom: 8
		disableDefaultUI: true
		mapTypeId: google.maps.MapTypeId.ROADMAP
	map = new google.maps.Map(document.getElementById("centermap"), myOptions)
