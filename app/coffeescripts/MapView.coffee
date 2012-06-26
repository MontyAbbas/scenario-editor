class window.sirius.MapView extends Backbone.View
  wypnts = []
  network_begin_end = []
  $a = window.sirius
  
  initialize: (network, broker) ->
    @broker = broker
    @network = network
    @contextMenu()
    @drawNetwork()
  
  @initializeMap: ->
    mapOptions = {
      center: new google.maps.LatLng(37.85794730789898, -122.29954719543457)
      zoom: 14
      mapTypeId: google.maps.MapTypeId.ROADMAP
      mapTypeControl: false
      zoomControl: true
      zoomControlOptions: {
        style: google.maps.ZoomControlStyle.DEFAULT,
        position: google.maps.ControlPosition.TOP_LEFT
      }
    }
    window.map = new google.maps.Map document.getElementById("map_canvas"), mapOptions
  
  drawNetwork: ->
    window.map.setCenter($a.Util.getLatLng(@network))
    @_drawNodes @network.get('nodelist').get('node')
    @_drawSensors @network.get('sensorlist').get('sensor')
    @_drawRoute
  
  _drawRoute: ->
    _linkInformationForMap()
    renderOptions = {
      map: window.map,
      markerOptions: {visible: false},
      preserveViewport: true
    }
    @directionsService = new google.maps.DirectionsService()
    @directionsDisplay = new google.maps.DirectionsRenderer(renderOptions)

    for x in [0..wypnts.length] by 8  
      #Create DirectionsRequest using DRIVING directions.
      request = {
        origin: network_begin_end[0],
        destination: network_begin_end[1],
        waypoints: wypnts[x...x+8],
        travelMode: google.maps.TravelMode.DRIVING,
      }
      #Route the directions and pass the response to a
      #function to draw the full link for each step.
      self = this
      @directionsService.route(request, (response, status) =>
        if (status == google.maps.DirectionsStatus.OK)
          warnings = $("#warnings_panel")
          warnings.innerHTML = "" + response.routes[0].warnings + ""
          _drawLinks response.routes[0].legs
      )

  _linkInformationForMap: ->
    net = window.textarea_scenario.get('networklist').get('network')[0]
    _.each(net.get('linklist').get('link'), (link) -> 
      @begin =  link.get('begin').get('node')
      @end = link.get('end').get('node')
      determineWayPointsAndNetworkStartEnd(@begin,@end)
    )


  _determineWayPointsAndNetworkStartEnd: (begin,end) ->
      #if it is not a terminal node, then it is a waypoint for the directions request
      if begin.get("type") != "terminal"
        wypnts.push { location:window.sirius.Util.getLatLng(begin) }
      else
        network_begin_end.push window.sirius.Util.getLatLng(begin)

      if end.get("type") == "terminal"
        network_begin_end.push window.sirius.Util.getLatLng(end)

  _drawLinks: (links) ->
    _.each(links, (i) ->  new $a.MapLinkView(i,@broker))

  _drawNodes: (nodes) ->
    _.each(nodes, (i) ->  new $a.MapNodeView(i,@broker,$a.Util.getLatLng(i)))

  _drawSensors: (sensors) ->
      _.each(sensors, (i) ->  new $a.MapSensorView(i,@broker,$a.Util.getLatLng(i)))

  contextMenu: () ->
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
  