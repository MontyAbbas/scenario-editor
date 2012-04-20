window.main_stuff.init = ->
	$("#load_scenario").click ->
      xml_text = $("#scenario_text").val()
      xml = $.parseXML(xml_text)
      window.textarea_scenario = window.aurora.Scenario.from_xml($(xml).children())
      window.main_stuff.display()

	myOptions =
    center: new google.maps.LatLng(37, -122)
    zoom: 14
    mapTypeId: google.maps.MapTypeId.ROADMAP
    mapTypeControl: false
    zoomControl: true
    zoomControlOptions: {
      style: google.maps.ZoomControlStyle.DEFAULT,
	    position: google.maps.ControlPosition.TOP_LEFT
     }
   window.map = new google.maps.Map(document.getElementById("map_canvas"),myOptions)
  
window.main_stuff.display = ->
	network = window.textarea_scenario.get('network')
	window.map.setCenter(new google.maps.LatLng(getLat(network), getLng(network)))
	drawNodes(network.get('nodelist').get('node'))
	drawSensors(network.get('sensorlist').get('sensor'))
	drawLinks(network.get('linklist').get('link'))
  # node.lat = window.textarea_scenario.get('network').get('nodelist').get('node')[0].get('position').get('point')[0].get('lat')
  # node.lng = window.textarea_scenario.get('network').get('nodelist').get('node')[0].get('position').get('point')[0].get('lng')
  # node1.lat = window.textarea_scenario.get('network').get('nodelist').get('node')[1].get('position').get('point')[0].get('lat')
  # node1.lng = window.textarea_scenario.get('network').get('nodelist').get('node')[1].get('position').get('point')[0].get('lng')
  # window.map.setCenter(new google.maps.LatLng(node.lat, node.lng))
  # marker = getMarker(new google.maps.LatLng(node.lat, node.lng))
  # marker1 = getMarker(new google.maps.LatLng(node1.lat, node1.lng))
  # getPolyLine(marker,marker1)

drawNodes = (nodes) ->
	for node in nodes 
			getMarker(node,"Node")

drawSensors = (sensors) ->
	for sensor in sensors
			getMarker(sensor,"Sensor")

getLat = (elem) ->
		elem.get('position').get('point')[0].get('lat')

getLng = (elem) ->
		elem.get('position').get('point')[0].get('lng')


getPolyLine = (marker1, marker2) ->
	new google.maps.Polyline({
	    path: [marker1.getPosition(),marker2.getPosition()],
	    strokeColor: "#240489",
	    strokeOpacity: 0.6,
	    strokeWeight: 10,
			map: window.map
	  });
	
getMarker = (elem,type) ->
	new google.maps.Marker({
					position: new google.maps.LatLng(getLat(elem), getLng(elem)),
					map: window.map,
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

roundDec = (num,dec) ->
		Math.round(num * Math.pow(10,dec)) / Math.pow(10,dec)