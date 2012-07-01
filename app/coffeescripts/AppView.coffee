# AppView is main organizing view for the application
# It handles all the application level elements as well as
# instantiating and triggering the Network to be drawn
class window.sirius.AppView extends Backbone.View
  $a = window.sirius
  
  # static instance level event aggegator that most classes use to register their
  # own listeners on
  @broker = _.clone(Backbone.Events)

  initialize: ->
    @render()

  render: ->
    @_initializeMap()
    @_contextMenu()
    @

  # create the landing map. The latitude and longitude our arbitarily pointing
  # to the I80/Berkeley area
  _initializeMap: ->
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

  # This creates the context menu as well as adds the listeners for map area of the application.
  # Currently we have zoom in and zoom out as well as center the map. 
  _contextMenu: () ->
    contextMenuOptions = {}
    contextMenuOptions.classNames = {menu:'context_menu', menuSeparator:'context_menu_separator'}
    menuItems = []
    menuItems.push {className:'context_menu_item', eventName:'zoom_in_click', label:'Zoom in'}
    menuItems.push {className:'context_menu_item', eventName:'zoom_out_click', label:'Zoom out'}
    menuItems.push {}
    menuItems.push {className:'context_menu_item', eventName:'center_map_click', label:'Center map here'}
    contextMenuOptions.menuItems=menuItems
    contextMenu = new ContextMenu(window.map, contextMenuOptions)
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

  # This static function is called by the File upload handler. It will load
  # the xml file, parse it into objects, assign it to window.textarea_scenario, and finally
  # call displayMap to start the rendering process
  @handleFiles : (files) ->
    reader = new FileReader()
    self = @
    reader.onloadend = (e) ->
      xml_text = e.target.result
      xml = $.parseXML(xml_text)
      window.textarea_scenario = $a.Scenario.from_xml($(xml).children())
      self._displayMap()
      
    reader.readAsText(files[0])

  # _displayMap creates the MapNetworkView and trigger the rendering event
  # for the network
  @_displayMap: ->
    @mapView = new $a.MapNetworkView window.textarea_scenario

