aurora_classes_with_extensions = [
  'Begin','Capacity','Controller', 'ControllerSet',
  'Data_sources','Demand', 'Density', 'Display_position',
  'Dynamics', 'End', 'Event', 'EventSet', 'Fd', 'Input',
  'Intersection', 'Link', 'LinkList', 'MonitorList',
  'Network', 'NetworkList', 'Node', 'NodeList', 'Od',
  'ODList', 'Output', 'PathList', 'Phase', 'Plan', 'PlanList',
  'PlanSequence', 'Point', 'Position', 'Qmax', 'Scenario',
  'Sensor', 'SensorList', 'Settings', 'Signal', 'SignalList',
  'Source', 'Splitratios'
]

aurora_classes_without_extensions = [
  'ALatLng', 'ArrayText', 'CapacityProfileSet', 'Components',
  'Control', 'Controlled', 'DemandProfileSet', 'Description',
  'DirectionsCacheEntry', 'DirectionsCache', 'Display', 'EncodedPolyline',
  'From', 'InitialDensityProfile', 'Inputs', 'IntersectionCacheEntry',
  'IntersectionCache', 'Lane_count_change', 'Levels', 'Limits',
  'LinkGeometry', 'LinkPairs', 'Links', 'Lkid', 'Monitored', 'Monitor',
  'Monitors', 'Onramp', 'Onramps', 'Outputs', 'Pair', 'Parameter',
  'Parameters', 'Path', 'Plan_reference', 'Points', 'Postmile',
  'Qcontroller', 'SplitRatioProfileSet', 'Srm', 'Stage', 'Table',
  'To', 'Units', 'VehicleTypes', 'Vtype', 'Weavingfactors', 'Wfm',
  'Zone', 'Zones'
]

load_aurora_classes = (after) ->
  head.js "js/Aurora.js", ->
    class_paths = _.map(aurora_classes_without_extensions, (cname) -> "js/#{cname}.js")
    class_paths = class_paths.concat _.flatten(_.map(
      aurora_classes_with_extensions,
      (cname) -> ["js/#{cname}.js","js/extensions/#{cname}.js"]
    ))
    class_paths.push after
    head.js.apply(@, class_paths)

head.js('../shared/jquery-1.7.1.js',
        '../shared/underscore.js',
        '../shared/backbone.js',
        '../shared/bootstrap/js/bootstrap.js', ->
            load_aurora_classes ->
              $("#load_scenario").click ->
                xml_text = "" #$("#scenario_text").val()
                #window.textarea_scenario = window.aurora.Scenario.from_xml($(xml_text))
                window.main_stuff.display_marks()
								
)

window.main_stuff.init = ->
  myOptions =
    center: new google.maps.LatLng(37.85298358928589, -122.29984760284424)
    zoom: 14
    mapTypeId: google.maps.MapTypeId.ROADMAP

  window.map = new google.maps.Map(document.getElementById("map_canvas"),
      myOptions)

  drawingManager = new google.maps.drawing.DrawingManager(
        drawingMode: google.maps.drawing.OverlayType.MARKER
        drawingControl: true
    
        drawingControlOptions:
          position: google.maps.ControlPosition.TOP_CENTER
          drawingModes: [
            google.maps.drawing.OverlayType.MARKER,
            google.maps.drawing.OverlayType.CIRCLE
          ]
    
        markerOptions:
          icon: 'data/img/dot.png"
    
        circleOptions:
          fillColor: '#ffff00'
          fillOpacity: 1
          strokeWeight: 5
          clickable: false
          zIndex: 1
          editable: true
    
      )
      
      drawingManager.setMap(window.map)
    	window.main_stuff.display_marks()
		
window.main_stuff.display_marks = ->
	window.map.setCenter(new google.maps.LatLng(37.85298358928589, -122.29984760284424))
	marker = getMarker(new google.maps.LatLng(37.85298358928589, -122.29984760284424))
	marker1 = getMarker(new google.maps.LatLng(37.86213208939834, -122.30229377746582))
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
