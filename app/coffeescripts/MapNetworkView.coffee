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
    @_drawNetwork()
    
    # This class creates the tree view of all the elements of the network
    new window.sirius.TreeView({ scenario: @scenario, attach: "#right_tree"})
    @render()
  
  render: ->
    $a.broker.trigger('map:init')
    $a.broker.trigger('app:main_tree')
    @
  
  # _drawNetwork is organizing function calling all the methods that
  # instantiate the various elements of the network
  _drawNetwork: ->
    $a.map.setCenter($a.Util.getLatLng(@network))
    @_drawRoute()
    @_drawNodes @network.get('nodelist').get('node') if @network.get('nodelist')?
    @_drawSensors @scenario.get('sensorlist').get('sensor') if @scenario.get('sensorlist')?
    @_drawControllers @scenario.get('controllerset').get('controller') if @scenario.get('controllerset')?
    @_drawEvents  @scenario.get('eventset').get('event') if @scenario.get('eventset')?
    @_drawSignals @scenario.get('signallist').get('signal') if @scenario.get('signallist')?


  # _drawRoute uses the Google Direction's api to get the data used to render the route.
  _drawRoute: ->
    @directionsService = new google.maps.DirectionsService()
    @_requestLink(@network.get('linklist').get('link').length - 1)

  # recursive method used to grab the Google route for every link
  # indexOfLink starts at the end of the link list and is decreased 
  # on each recrusive call
  _requestLink: (indexOfLink) ->
    if indexOfLink > -1
      link = @network.get('linklist').get('link')[indexOfLink]
      begin =  link.get('begin').get('node')
      end = link.get('end').get('node')
      #Create DirectionsRequest using DRIVING directions.
      request = {
       origin: $a.Util.getLatLng(begin),
       destination: $a.Util.getLatLng(end),
       travelMode: google.maps.TravelMode.DRIVING,
      }
      # request the route from the directions service.
      # The parameters are the request object for Google API
      # as well as 0, indicating the number of attempts -- read
      # below
      @_directionsRequest(request, link, 0)
      @_requestLink(indexOfLink - 1)
  
  # _directionsRequest makes the actual route request to google. if we recieve OVER_QUERY_LIMIT error, this method
  # will wait 3 seconds and then call itself again with the same request object but montior the number of attempts.
  # We attempt to get the route for the link 3 times and then give up. If get a route, this method calls _drawLink
  # to render the link on the page
  _directionsRequest: (request, linkModel, attempts) ->
    self = @
    @directionsService.route(request, (response, status) ->
      if (status == google.maps.DirectionsStatus.OK)
        warnings = $("#warnings_panel")
        warnings.innerHTML = "" + response.routes[0].warnings + ""
        self._drawLink linkModel, response.routes[0].legs
      else if status == google.maps.DirectionsStatus.OVER_QUERY_LIMIT and attempts < 3
        setTimeout (() -> self._directionsRequest(request, linkModel, attempts + 1)), 3000
      else #TODO configure into html
        warnings = $("#warnings_panel")
        warnings.innerHTML = "Directions API Error: Could not render link : " + status + ""
    )

  # These methods instantiate each elements view instance in the map
  _drawLink: (linkModel, legs) ->
    new $a.MapLinkView(linkModel, legs)

  _drawNodes: (nodes) ->
    _.each(nodes, (i) ->  new $a.MapNodeView(i))

  _drawSensors: (sensors) ->
    _.each(sensors, (i) ->  new $a.MapSensorView(i, $a.MapNetworkModel.LINKS))

  _drawEvents: (events) ->
    _.each(events, (i) ->  new $a.MapEventView(i))

  _drawControllers: (controllers) ->
    _.each(controllers, (i) -> new $a.MapControllerView(i))

  _drawSignals: (signals) ->
    _.each(signals, (i) ->  new $a.MapSignalView(i) if $a.Util.getLatLng(i)?)

    