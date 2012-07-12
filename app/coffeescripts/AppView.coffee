# AppView is main organizing view for the application
# It handles all the application level elements as well as
# instantiating and triggering the Network to be drawn
class window.sirius.AppView extends Backbone.View
  $a = window.sirius
  $a.SHIFT_DOWN = false
  
  initialize: ->
    #change underscores symbols for handling interpolation to {{}}
    _.templateSettings = {interpolate : /\{\{(.+?)\}\}/g }
    @render()

  render: ->
    @_initializeMap()
    @_navBar()
    @_contextMenu()
    @_layersMenu()
    self = @
    google.maps.event.addDomListener(window, 'keydown', (event) -> self._setKeyEvents(event))
    $a.broker.on('map:upload_complete', @_displayMap, @)
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
    #attach the map to the namespace
    $a.map = new google.maps.Map document.getElementById("map_canvas"), mapOptions

  # This creates the context menu as well as adds the listeners for map area of the application.
  # Currently we have zoom in and zoom out as well as center the map. 
  _contextMenu: () ->
    contextMenuOptions = {}
    contextMenuOptions.menuItems= $a.main_context_menu
    contextMenuOptions.id='main-context-menu'
    contextMenuOptions.class='context_menu'
    $a.contextMenu = new $a.ContextMenuView(contextMenuOptions)
    google.maps.event.addListener($a.map, 'rightclick', (mouseEvent) -> $a.contextMenu.show mouseEvent.latLng )

  # This creates the main navigation bar menu
  _navBar: () ->
    new $a.FileUploadView({name: "localNetwork", id : "uploadField", attach: "#main-nav div"})
    new $a.NavBarView({menuItems: $a.nav_bar_menu_items, attach: "#main-nav div"})

  # This creates the layers menu bar
  _layersMenu: () ->
    lmenu = new $a.LayersMenuView({className: 'dropdown-menu bottom-up', id : 'l_list', parentId: 'lh', menuItems: $a.layers_menu})
    # we'll need to get rid of this call -- it is doing things that it shouldn't do to the modals, clear map, etc
    lmenu.attachEvents()

  # displayMap takes the uploaded file data parses the xml into the model objects, and creates the MapNetworkView
  _displayMap: (fileText) ->
    try
      xml = $.parseXML(fileText)
    catch error
      $a.broker.trigger("map:alert", error, "alert-error")
    $a.models = $a.Scenario.from_xml($(xml).children())
    new $a.MapNetworkModel()
    @mapView = new $a.MapNetworkView $a.models

  _setKeyEvents: (e) ->
    # Open Local Network ALT-A
    $("#uploadField").click() if e.type == 'keydown' and $a.ALT_DOWN and e.keyCode == 65
    
    # Set multi-select of map elements with the shift key
    $a.SHIFT_DOWN = false
    $a.SHIFT_DOWN = true if e.type == 'keydown' and e.keyCode == 16
    
    # Set multi-select of map elements with the shift key
    $a.ALT_DOWN = false
    $a.ALT_DOWN = true if e.type == 'keydown' and e.keyCode == 18
