$ ->
	myOptions =
		center: new google.maps.LatLng(37.76918346431238, -122.43491845703124)
		zoom: 15
		disableDefaultUI: true
		mapTypeId: google.maps.MapTypeId.ROADMAP

	map = new google.maps.Map(document.getElementById("centermap"), myOptions)

	wiggleCoords = [
		[37.7743227590708, -122.4358840522766] # Fell and Scott
		[37.7714224089108, -122.43539052581787] # Scott and Haight
		[37.7716937915282, -122.43365245437622] # Haight and Pierce
		[37.7707269864072, -122.43348079299926] # Pierce and Waller
		[37.7709644484853, -122.43187146759033] # Waller and Steiner
	]

	poly = new google.maps.Polyline(
		strokeColor: '#ff0000',
		strokeOpacity: 1.0,
		strokeWeight: 3
	)

	poly.setMap map
	path = poly.getPath()

	wiggleLatLngs = _.map(wiggleCoords, (latlngarray) ->
		new google.maps.LatLng(latlngarray[0], latlngarray[1]))

	_.each(wiggleLatLngs, (latlng, idx) ->
		marker = new google.maps.Marker(
			position: latlng
			map: map
			title: 'x'
		)
		path.push latlng
	)
	###
	Code to capture clicked coordinates
	google.maps.event.addListener map, 'click', (mouseEvent) ->
		latLng = mouseEvent.latLng
		lat = latLng.lat()
		lng = latLng.lng()
		console.log lat, lng
	###
