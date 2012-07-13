directionsDisplay = {}
directionsService = {}
	
window.main_stuff.init = ->
	$("#load_scenario").click ->
		xml_text = $("#scenario_text").val()
		xml = $.parseXML(xml_text)
		window.textarea_scenario = window.aurora.Scenario.from_xml($(xml).children())
		window.main_stuff.display()
	
	myOptions =
		center: new google.maps.LatLng(37.85794730789898, -122.29954719543457)
		zoom: 14
		mapTypeId: google.maps.MapTypeId.ROADMAP
		mapTypeControl: false
		zoomControl: true
		zoomControlOptions: {
			style: google.maps.ZoomControlStyle.DEFAULT,
			position: google.maps.ControlPosition.TOP_LEFT
		}
	$a.map = new google.maps.Map(document.getElementById("map_canvas"),myOptions)
	
	renderer_options =
		map: $a.map

	directionsDisplay = new google.maps.DirectionsRenderer(renderer_options);
	directionsService = new google.maps.DirectionsService();

window.main_stuff.display = ->
	node_markers = {}
	broker = _.clone( Backbone.Events)
	network = window.textarea_scenario.get('network')
	$a.map.setCenter(new google.maps.LatLng(getLat(network), getLng(network)))
	drawNodes network.get('nodelist').get('node'), broker
	broker.trigger('map:init')
	#drawSensors(network.get('sensorlist').get('sensor'))
	#drawLinks(network.get('linklist').get('link'))
	#drawLinks(network.get('linklist').get('link'))
  # node.lat = window.textarea_scenario.get('network').get('nodelist').get('node')[0].get('position').get('point')[0].get('lat')
  # node.lng = window.textarea_scenario.get('network').get('nodelist').get('node')[0].get('position').get('point')[0].get('lng')
  # node1.lat = window.textarea_scenario.get('network').get('nodelist').get('node')[1].get('position').get('point')[0].get('lat')
  # node1.lng = window.textarea_scenario.get('network').get('nodelist').get('node')[1].get('position').get('point')[0].get('lng')
  # $a.map.setCenter(new google.maps.LatLng(node.lat, node.lng))
  # marker = getMarker(new google.maps.LatLng(node.lat, node.lng))
  # marker1 = getMarker(new google.maps.LatLng(node1.lat, node1.lng))
  # getPolyLine(marker,marker1)

drawLinks = (links) ->
	for link in links
		marker_begin = getMarker(link.get('begin').get('node'),"Node")
		marker_end = getMarker(link.get('end').get('node'),"Node")
		drawRoute(marker_begin,marker_end)
		
drawNodes = (nodes,broker) ->
	_.each(nodes, (i) ->  new window.aurora.MapNodeView(i,broker,getLat(i), getLng(i)))

drawSensors = (sensors,broker) ->
	_.each(sensors, (i) ->  new window.aurora.MapSensorView(i,broker,getLat(i), getLng(i)))

getLat = (elem) ->
		elem.get('position').get('point')[0].get('lat')

getLng = (elem) ->
		elem.get('position').get('point')[0].get('lng')

drawPolyLine = (marker1, marker2) ->
	new google.maps.Polyline({
	    path: [marker1.getPosition(),marker2.getPosition()],
	    strokeColor: "#240489",
	    strokeOpacity: 0.6,
	    strokeWeight: 10,
			map: $a.map
	  });


drawRoute = (start, end) -> 
		request = 
			origin: start.getPosition(),
			destination: end.getPosition(),
			travelMode: google.maps.TravelMode.DRIVING

		directionsService.route(request, (response, status) ->
			if (status == google.maps.DirectionsStatus.OK) 
				directionsDisplay.setDirections(response);
			);
		
getMarker = (elem,type) ->
	new google.maps.Marker({
					position: new google.maps.LatLng(getLat(elem), getLng(elem)),
					map: $a.map,
					draggable: true,
					clickable: true,
					hasShadow: false,
					icon: getMarkerImage(elem,type),
					title: type + ": " + elem.get('name') + "\nLatitude: " + roundDec(getLat(elem),4) + "\nLongitude: " + roundDec(getLng(elem),4)
		  	});

getMarkerImage = (elem,type) ->
	switch type
		when "Sensor" then img = "camera-orig"
		when "Node" 	
			img = if elem.get('type') != "T" then "dot" else "square"
	
	new google.maps.MarkerImage('data/img/' + img + '.png',
				      new google.maps.Size(32, 32),
				      new google.maps.Point(0,0),
				      new google.maps.Point(16, 16));


	
	
	