window.main_stuff.init = ->
	$("#load_scenario").click ->
      xml_text = $("#scenario_text").val()
      xml = $.parseXML(xml_text)
      window.textarea_scenario = window.aurora.Scenario.from_xml($(xml).children())
      window.main_stuff.display_marks()

	myOptions =
    center: new google.maps.LatLng(37.85298358928589, -122.29984760284424)
    zoom: 14
    mapTypeId: google.maps.MapTypeId.ROADMAP
    mapTypeControl: false
    zoomControl: true
    zoomControlOptions: {
      style: google.maps.ZoomControlStyle.DEFAULT,
      position: google.maps.ControlPosition.TOP_LEFT
    }
	
  window.map = new google.maps.Map(document.getElementById("map_canvas"),myOptions)
  
  # drawingManager = new google.maps.drawing.DrawingManager(
  #         drawingMode: google.maps.drawing.OverlayType.MARKER
  #         drawingControl: true
  #     
  #         drawingControlOptions:
  #           position: google.maps.ControlPosition.TOP_CENTER
  #           drawingModes: [
  #             google.maps.drawing.OverlayType.MARKER,
  #             google.maps.drawing.OverlayType.CIRCLE
  #           ]
  #     
  #         markerOptions:
  #           icon: "data/img/dot.png"
  #     
  #         circleOptions:
  #           fillColor: "#ffff00"
  #           fillOpacity: 1
  #           strokeWeight: 5
  #           clickable: false
  #           zIndex: 1
  #           editable: true
  #     
  #       )
  #       
  #       drawingManager.setMap(window.map)
  #  		
window.main_stuff.display_marks = ->
  node = {}
  node1 = {}
  node.lat = window.textarea_scenario.get('network').get('nodelist').get('node')[0].get('position').get('point')[0].get('lat')
  node.lng = window.textarea_scenario.get('network').get('nodelist').get('node')[0].get('position').get('point')[0].get('lng')
  node1.lat = window.textarea_scenario.get('network').get('nodelist').get('node')[1].get('position').get('point')[0].get('lat')
  node1.lng = window.textarea_scenario.get('network').get('nodelist').get('node')[1].get('position').get('point')[0].get('lng')
  window.map.setCenter(new google.maps.LatLng(node.lat, node.lng))
  marker = getMarker(new google.maps.LatLng(node.lat, node.lng))
  marker1 = getMarker(new google.maps.LatLng(node1.lat, node1.lng))
  getPolyLine(marker,marker1)

getPolyLine = (marker1, marker2) ->
	new google.maps.Polyline({
	    path: [marker1.getPosition(),marker2.getPosition()],
	    strokeColor: "#240489",
	    strokeOpacity: 0.6,
	    strokeWeight: 10,
			map: window.map
	  });
	
getMarker = (pos) ->
	new google.maps.Marker({
					position: pos,
					map: window.map,
					draggable: true,
					clickable: true,
					hasShadow: false,
					icon: getMarkerImage(),
					tooltip: "Hello"
		  	});

getMarkerImage = ->
	new google.maps.MarkerImage('data/img/dot.png',
				      new google.maps.Size(32, 32),
				      new google.maps.Point(0,0),
				      new google.maps.Point(16, 16));
