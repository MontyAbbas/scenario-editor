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
    zoomControlOptions:
      style: google.maps.ZoomControlStyle.DEFAULT,
      position: google.maps.ControlPosition.TOP_LEFT

  window.map = new google.maps.Map(document.getElementById("map_canvas"),myOptions)
  contextMenuOptions={}
  contextMenuOptions.classNames={menu:'context_menu', menuSeparator:'context_menu_separator'}
  menuItems=[]
  menuItems.push {className:'context_menu_item', eventName:'zoom_in_click', label:'Zoom in'}
  menuItems.push {className:'context_menu_item', eventName:'zoom_out_click', label:'Zoom out'}
  menuItems.push {}
  menuItems.push {className:'context_menu_item', eventName:'center_map_click', label:'Center map here'}
  contextMenuOptions.menuItems=menuItems
  contextMenu= new ContextMenu(window.map, contextMenuOptions)
  google.maps.event.addListener(window.map, 'rightclick', (mouseEvent) ->
    contextMenu.show mouseEvent.latLng
    null
  )

  google.maps.event.addListener(contextMenu, 'menu_item_selected', (latLng, eventName) ->
    switch eventName
      when 'zoom_in_click' then window.map.setZoom map.getZoom()+1
      when 'zoom_out_click' then window.map.setZoom map.getZoom()-1
      when 'center_map_click' then window.map.panTo latLng
    null
  )

window.main_stuff.display = ->  
  node_markers = {}
  broker = _.clone( Backbone.Events)
  network = window.textarea_scenario.get('network')
  window.map.setCenter(window.aurora.Util.getLatLng(network))
  drawNodes network.get('nodelist').get('node'), broker
  drawSensors network.get('sensorlist').get('sensor'), broker
  #drawLinks network.get('linklist').get('link'), broker
  setUpMap broker
  broker.trigger('map:init')

drawLinks = (links, broker) ->
  _.each(links, (i) ->  new window.aurora.MapLinkView(i,broker))

drawNodes = (nodes,broker) ->
  _.each(nodes, (i) ->  new window.aurora.MapNodeView(i,broker,window.aurora.Util.getLatLng(i)))

drawSensors = (sensors,broker) ->
  _.each(sensors, (i) ->  new window.aurora.MapSensorView(i,broker,window.aurora.Util.getLatLng(i)))

wypnts = []
network_begin_end = []
setUpMap = (broker) ->
  linkInformationForMap()
  renderOptions = {
    map: window.map,
    markerOptions: {visible: false},
    preserveViewport: true
  }
  this.directionsService = new google.maps.DirectionsService()
  this.directionsDisplay = new google.maps.DirectionsRenderer(renderOptions)
  
  #Create DirectionsRequest using DRIVING directions.
  request = {
    origin: network_begin_end[0],
    destination: network_begin_end[1],
    waypoints: wypnts,
    travelMode: google.maps.TravelMode.DRIVING,
  }
  #Route the directions and pass the response to a
  #function to draw the full link for each step.
  self = this
  this.directionsService.route(request, (response, status) =>
    if (status == google.maps.DirectionsStatus.OK)
      warnings = $("#warnings_panel")
      warnings.innerHTML = "" + response.routes[0].warnings + ""
      #self.directionsDisplay.setDirections(response)
      drawLinks response.routes[0].legs, broker
  )

  
linkInformationForMap = () ->
  net = window.textarea_scenario.get('network')
  _.each(net.get('linklist').get('link'), (link) -> 
    this.begin =  link.get('begin').get('node')
    this.end = link.get('end').get('node')
    determineWayPointsAndNetworkStartEnd(this.begin,this.end)
  )


determineWayPointsAndNetworkStartEnd = (begin,end) ->
    #if it is not a terminal node, I want it to make the directions request
    if begin.get("type") != "T"
      wypnts.push { location:window.aurora.Util.getLatLng(begin) }
    else
      network_begin_end.push window.aurora.Util.getLatLng(begin)

    if end.get("type") == "T"
      network_begin_end.push window.aurora.Util.getLatLng(end)