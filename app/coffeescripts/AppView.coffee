# AppView is main organizing view for the application
# It handles all the application level elements as well as
# instantiating and triggering the Network to be drawn
class window.sirius.AppView extends Backbone.View
  $a = window.sirius

  initialize: ->
    #change underscores symbols for handling interpolation to {{}}
    _.templateSettings = {interpolate : /\{\{(.+?)\}\}/g }
    @render()

  render: ->
    @_initializeMap()
    @_navBar()
    @_contextMenu()
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
    contextMenuOptions.classNames = {menu:'context_menu', menuSeparator:'context_menu_separator'}
    menuItems = []
    menuItems.push {className:'context_menu_item', eventName:'zoom_in_click', label:'Zoom in'}
    menuItems.push {className:'context_menu_item', eventName:'zoom_out_click', label:'Zoom out'}
    menuItems.push {}
    menuItems.push {className:'context_menu_item', eventName:'center_map_click', label:'Center map here'}
    contextMenuOptions.menuItems=menuItems
    contextMenu = new ContextMenu($a.map, contextMenuOptions)
    google.maps.event.addListener($a.map, 'rightclick', (mouseEvent) ->
      contextMenu.show mouseEvent.latLng
      null
    )

    google.maps.event.addListener(contextMenu, 'menu_item_selected', (latLng, eventName) ->
      switch eventName
        when 'zoom_in_click' then $a.map.setZoom map.getZoom()+1
        when 'zoom_out_click' then $a.map.setZoom map.getZoom()-1
        when 'center_map_click' then $a.map.panTo latLng
      null
    )

  # This creates the main navigation bar menu
  _navBar: () ->
    new $a.FileUploadView({name: "localNetwork", id : "uploadField", attach: "#main-nav div"})
    new $a.NavBarView({menuItems: $a.nav_bar_menu_items, attach: "#main-nav div"})

  # displayMap takes the uploaded file data parses the xml into the model objects, and creates the MapNetworkView
  _displayMap: (fileText) ->
    xml = $.parseXML(fileText)
    @mapView = new $a.MapNetworkView $a.Scenario.from_xml($(xml).children())

