class window.sirius.MapNetworkView extends Backbone.View
  wypnts = []
  network_begin_end = []
  $a = window.sirius
  
  initialize: (network, broker) ->
    @broker = broker
    @network = network
    @broker.on('map:init', @render(), @)
  
  render: ->  
    @drawNetwork()
  
  drawNetwork: ->
    window.map.setCenter($a.Util.getLatLng(@network))
    @_drawNodes @network.get('nodelist').get('node')
    @_drawSensors @network.get('sensorlist').get('sensor')
    @_drawRoute()
  
  _drawRoute: ->
    @_linkInformationForMap()
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
      self = @
      @directionsService.route(request, (response, status) =>
        if (status == google.maps.DirectionsStatus.OK)
          warnings = $("#warnings_panel")
          warnings.innerHTML = "" + response.routes[0].warnings + ""
          self._drawLinks response.routes[0].legs
      )

  _linkInformationForMap: ->
    net = window.textarea_scenario.get('networklist').get('network')[0]
    self = @
    _.each(net.get('linklist').get('link'), (link) -> 
      @begin =  link.get('begin').get('node')
      @end = link.get('end').get('node')
      self._determineWayPointsAndNetworkStartEnd(@begin,@end)
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
    self = @
    _.each(links, (i) ->  new $a.MapLinkView(i,self.broker))

  _drawNodes: (nodes) ->
    self = @
    _.each(nodes, (i) ->  new $a.MapNodeView(i,self.broker,$a.Util.getLatLng(i)))

  _drawSensors: (sensors) ->
    self = @
    _.each(sensors, (i) ->  new $a.MapSensorView(i,self.broker,$a.Util.getLatLng(i)))
