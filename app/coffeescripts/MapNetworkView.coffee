# The main class managing the view of the network on the map.
# A network consists of all the links, nodes, sensors, controllers
# events, and signals along a route. It uses the google api Directions
# Service to determine the route by passing the service
# a set of latitude and longitudes along the route(waypoints). 
#
# The class also creates and then triggers the rendering of the treeView 
# of the scenario elements.
class window.sirius.MapNetworkView extends Backbone.View
  $a = window.sirius
  
  initialize: (@scenario) ->
    @network =  @scenario.get('networklist').get('network')[0]
    @render()
  
  render: ->  
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
  _drawRoute: ->
    directionsService = new google.maps.DirectionsService()
    self = @
    _.each(self.network.get('linklist').get('link'), (link) -> 
      begin =  link.get('begin').get('node')
      end = link.get('end').get('node')
      #Create DirectionsRequest using DRIVING directions.
      request = {
        origin: $a.Util.getLatLng(begin),
        destination: $a.Util.getLatLng(end),
        travelMode: google.maps.TravelMode.DRIVING,
      }
      #Route the directions and pass the response to a
      #function to draw the full link for each step.
      directionsService.route(request, (response, status) =>
        if (status == google.maps.DirectionsStatus.OK)
          warnings = $("#warnings_panel")
          warnings.innerHTML = "" + response.routes[0].warnings + ""
          self._drawLinks response.routes[0].legs
        else #TODO configure into html
          warnings = $("#warnings_panel")
          warnings.innerHTML = "Directions API Error: " + status + ""
      )
    )
  

  # These methods instantiate each elements view instance in the map
  _drawLinks: (links) ->
    _.each(links, (i) ->  new $a.MapLinkView(i))

  _drawNodes: (nodes) ->
    _.each(nodes, (i) ->  new $a.MapNodeView(i, $a.Util.getLatLng(i)) if $a.Util.getLatLng(i)?)

  _drawSensors: (sensors) ->
    _.each(sensors, (i) ->  new $a.MapSensorView(i, $a.Util.getLatLng(i)) if $a.Util.getLatLng(i)?)

  _drawEvents: (events) ->
    _.each(events, (i) ->  new $a.MapEventView(i, $a.Util.getLatLng(i)) if $a.Util.getLatLng(i)?)

  _drawControllers: (controllers) ->
    _.each(controllers, (i) -> new $a.MapControllerView(i, $a.Util.getLatLng(i)) if $a.Util.getLatLng(i)?)

  _drawSignals: (signals) ->
    _.each(signals, (i) ->  new $a.MapSignalView(i, $a.Util.getLatLng(i)) if $a.Util.getLatLng(i)?)

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
