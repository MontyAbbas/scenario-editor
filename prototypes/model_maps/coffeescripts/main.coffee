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
                xml_text = $("#scenario_text").val()
                window.textarea_scenario = window.aurora.Scenario.from_xml($(xml_text))

)

window.main_stuff.init = ->
  myOptions =
    center: new google.maps.LatLng(37.85117239046442, -122.29111433029176)
    zoom: 8
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
      icon: 'http://code.google.com/apis/maps/documentation/javascript/examples/images/beachflag.png'

    circleOptions:
      fillColor: '#ffff00'
      fillOpacity: 1
      strokeWeight: 5
      clickable: false
      zIndex: 1
      editable: true

  )
  
  drawingManager.setMap(window.map)

window.main_stuff.display_marks = ->
	window.map.setCenter(new google.maps.LatLng(40.85117239046442, -122.29111433029176))
	