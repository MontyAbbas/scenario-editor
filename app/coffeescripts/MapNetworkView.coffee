class window.sirius.MapNetworkView extends Backbone.View
  wypnts = []
  network_begin_end = []
  $a = window.sirius
  
  initialize: (@scenario, @broker) ->
    @broker.on('map:init', @render(), @)
  
  render: ->  
    @network =  @scenario.get('networklist').get('network')[0]
    @drawNetwork()
  
  drawNetwork: ->
    window.map.setCenter($a.Util.getLatLng(@network))
    @_drawNodes @network.get('nodelist').get('node') if @network.get('nodelist')
    @_drawSensors @network.get('sensorlist').get('sensor') if @network.get('sensorlist')
    @_drawControllers @scenario.get('controllerset').get('controller') if @scenario.get('controllerset')
    @_drawEvents  @scenario.get('eventset').get('event') if @scenario.get('eventset')
    @_drawSignals @network.get('signallist').get('signal') if @network.get('signallist')
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
    self = @
    _.each(self.network.get('linklist').get('link'), (link) -> 
      @begin =  link.get('begin').get('node')
      @end = link.get('end').get('node')
      self._determineWayPointsAndNetworkStartEnd(@begin,@end)
    )

  _determineWayPointsAndNetworkStartEnd: (begin,end) ->
      #if it is not a terminal node, then it is a waypoint for the directions request
      if begin.get("type") != "terminal"
        wypnts.push { location:$a.Util.getLatLng(begin) }
      else
        network_begin_end.push $a.Util.getLatLng(begin)

      if end.get("type") == "terminal"
        network_begin_end.push $a.Util.getLatLng(end)

  _drawLinks: (links) ->
    self = @
    _.each(links, (i) ->  new $a.MapLinkView(i,self.broker))

  _drawNodes: (nodes) ->
    self = @
    _.each(nodes, (i) ->  new $a.MapNodeView(i,self.broker,$a.Util.getLatLng(i)))

  _drawSensors: (sensors) ->
    self = @
    _.each(sensors, (i) ->  new $a.MapSensorView(i,self.broker,$a.Util.getLatLng(i)))

  _drawEvents: (events) ->
    self = @
    _.each(events, (i) ->  new $a.MapEventView(i,self.broker,$a.Util.getLatLng(i)))

  _drawControllers: (controllers) ->
    self = @
    _.each(controllers, (i) ->  new $a.MapControllerView(i,self.broker,$a.Util.getLatLng(i)))

  _drawSignals: (signals) ->
    self = @
    _.each(signals, (i) ->  new $a.MapSignalView(i,self.broker,$a.Util.getLatLng(i)))
