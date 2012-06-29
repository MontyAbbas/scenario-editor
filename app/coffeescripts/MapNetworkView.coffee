# The main class managing the view of the network on the map.
# A network consists of all the links, nodes, sensors, controllers
# events, and signals along a route. It uses the google api Directions
# Service to determine the route by passing the service
# a set of latitude and longitudes along the route(waypoints). Due to 
# limitations in the google service, you'll notice that we need to make 
# multiple calls to the routes for every 8 waypoints.
#
# The class also creates and then triggers the rendering of the treeView 
# of the scenario elements.
class window.sirius.MapNetworkView extends Backbone.View
  wypnts = []
  network_begin_end = []
  $a = window.sirius
  
  initialize: (@scenario) ->
    $a.AppView.broker.on('map:init', @render(), @)
  
  render: ->  
    @network =  @scenario.get('networklist').get('network')[0]
    @_drawNetwork()
    @_treeView()
    @
  
  # _drawNetwork is organizing function calling all the methods that
  # instantiate the various elements of the network
  _drawNetwork: ->
    window.map.setCenter($a.Util.getLatLng(@network))
    @_drawNodes @network.get('nodelist').get('node') if @network.get('nodelist')
    @_drawSensors @network.get('sensorlist').get('sensor') if @network.get('sensorlist')
    @_drawControllers @scenario.get('controllerset').get('controller') if @scenario.get('controllerset')
    @_drawEvents  @scenario.get('eventset').get('event') if @scenario.get('eventset')
    @_drawSignals @network.get('signallist').get('signal') if @network.get('signallist')
    @_drawRoute()
  
  # _drawRoute uses the Google Direction's api to get the data used to render the route.
  # Note again that a calls to @directionsService.route is made for every 8 way points along
  # the route
  _drawRoute: ->
    @_linkInformationForMap()
    directionsService = new google.maps.DirectionsService()

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
      directionsService.route(request, (response, status) =>
        if (status == google.maps.DirectionsStatus.OK)
          warnings = $("#warnings_panel")
          warnings.innerHTML = "" + response.routes[0].warnings + ""
          self._drawLinks response.routes[0].legs
      )

  # This method is used to determine the begin and end points
  # of each link as well as to store the waypoints used to
  # get an accurate path from the beginning to the end of each link
  _linkInformationForMap: ->
    self = @
    _.each(self.network.get('linklist').get('link'), (link) -> 
      @begin =  link.get('begin').get('node')
      @end = link.get('end').get('node')
      self._determineWayPointsAndNetworkStartEnd(@begin,@end)
    )

  # Called by _linkInformationForMap to determine if begin or end are
  # the terminal points of the link and if not to push the begin point
  # into the waypoints array
  _determineWayPointsAndNetworkStartEnd: (begin,end) ->
      #if it is not a terminal node, then it is a waypoint for the directions request
      if begin.get("type") != "terminal"
        wypnts.push { location:$a.Util.getLatLng(begin) }
      else
        network_begin_end.push $a.Util.getLatLng(begin)

      if end.get("type") == "terminal"
        network_begin_end.push $a.Util.getLatLng(end)

  # These methods instantiate each elements view instance in the map
  _drawLinks: (links) ->
    _.each(links, (i) ->  new $a.MapLinkView(i))

  _drawNodes: (nodes) ->
    _.each(nodes, (i) ->  new $a.MapNodeView(i, $a.Util.getLatLng(i)))

  _drawSensors: (sensors) ->
    _.each(sensors, (i) ->  new $a.MapSensorView(i, $a.Util.getLatLng(i)))

  _drawEvents: (events) ->
    _.each(events, (i) ->  new $a.MapEventView(i, $a.Util.getLatLng(i)))

  _drawControllers: (controllers) ->
    _.each(controllers, (i) ->  new $a.MapControllerView(i, $a.Util.getLatLng(i)))

  _drawSignals: (signals) ->
    _.each(signals, (i) ->  new $a.MapSignalView(i, $a.Util.getLatLng(i)))

  # This method creates the tree view of all the elements of the network
  _treeView: ->
    self = @
    _.each window.main_tree_elements, (e) ->  new $a.TreeParentItemView(e)
    _.each(@scenario.get('networklist').get('network'), (e) -> new $a.TreeChildItemView(e, "network-list")) if @scenario.get('networklist')?
    _.each(@scenario.get('networkconnections').get('network'), (e) -> new $a.TreeChildItemView(e, "network-connections")) if @scenario.get('networkconnections')?
    _.each(@scenario.get('controllerset').get('controller'), (e) -> new $a.TreeChildItemView(e, "controllers")) if @scenario.get('controllerset')?
    _.each(@scenario.get('initialdensityset').get('density'), (e) -> new $a.TreeChildItemView(e, "initial-density-profiles")) if @scenario.get('initialdensityset')?
    _.each(@scenario.get('demandprofileset').get('demandprofile'), (e) -> new $a.TreeChildItemView(e, "demand-profiles")) if @scenario.get('demandprofileset')?
    _.each(@scenario.get('eventset').get('event'), (e) -> new $a.TreeChildItemView(e, "events")) if @scenario.get('eventset')?
    _.each(@scenario.get('fundamentaldiagramprofileset').get('fundamentaldiagramprofile'), (e) -> new $a.TreeChildItemView(e, "fundamental-diagram-profiles")) if @scenario.get('fundamentaldiagramprofileset')?
    _.each(@scenario.get('oddemandprofileset').get('oddemandprofile'), (e) -> new $a.TreeChildItemView(e, "od-demand-profiles")) if @scenario.get('oddemandprofileset')?
    _.each(@scenario.get('downstreamboundarycapacityprofileset').get('downstreamboundarycapacityprofile'), (e) -> 
                                                    new $a.TreeChildItemView(e, "downstream-boundary-capacity-profiles")) if @scenario.get('downstreamboundarycapacityprofileset')?
    _.each(@scenario.get('splitratioprofileset').get('splitratioprofile'), (e) -> new $a.TreeChildItemView(e, "split-ratio-profiles")) if @scenario.get('splitratioprofileset')?
    _.each(@scenario.get('sensorlist').get('sensor'), (e) -> new $a.TreeChildItemView(e, "sensors")) if @scenario.get('sensorlist')?
    _.each(@scenario.get('signallist').get('signal'), (e) -> new $a.TreeChildItemView(e, "signals")) if @scenario.get('signallist')?
