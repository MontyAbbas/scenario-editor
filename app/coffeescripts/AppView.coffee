class window.sirius.AppView extends Backbone.View
  $a = window.sirius
  @broker = _.clone(Backbone.Events)

  initialize: ->
    @initializeMap()
    @contextMenu()

  contextMenu: () ->
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

  @handleFiles : (files) ->
    reader = new FileReader()
    self = @
    reader.onloadend = (e) ->
      xml_text = e.target.result
      xml = $.parseXML(xml_text)
      window.textarea_scenario = $a.Scenario.from_xml($(xml).children())
      self.displayMap()

    reader.readAsText(files[0])

  @displayMap: ->
    scenario = window.textarea_scenario
    @mapView = new $a.MapNetworkView scenario, @broker
    @treeView()
    AppView.broker.trigger('map:init')

  initializeMap: ->
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

  @treeView: ->
    $w= window.textarea_scenario
    self = @
    _.each window.main_tree_elements, (e) ->  new $a.TreeParentItemView(e)
    _.each($w.get('networklist').get('network'), (e) -> new $a.TreeChildItemView(e, "network-list")) if $w.get('networklist')?
    _.each($w.get('networkconnections').get('network'), (e) -> new $a.TreeChildItemView(e, "network-connections")) if $w.get('networkconnections')?
    _.each($w.get('controllerset').get('controller'), (e) -> new $a.TreeChildItemView(e, "controllers")) if $w.get('controllerset')?
    _.each($w.get('initialdensityset').get('density'), (e) -> new $a.TreeChildItemView(e, "initial-density-profiles")) if $w.get('initialdensityset')?
    _.each($w.get('demandprofileset').get('demandprofile'), (e) -> new $a.TreeChildItemView(e, "demand-profiles")) if $w.get('demandprofileset')?
    _.each($w.get('eventset').get('event'), (e) -> new $a.TreeChildItemView(e, "events")) if $w.get('eventset')?
    _.each($w.get('fundamentaldiagramprofileset').get('fundamentaldiagramprofile'), (e) -> new $a.TreeChildItemView(e, "fundamental-diagram-profiles")) if $w.get('fundamentaldiagramprofileset')?
    _.each($w.get('oddemandprofileset').get('oddemandprofile'), (e) -> new $a.TreeChildItemView(e, "od-demand-profiles")) if $w.get('oddemandprofileset')?
    _.each($w.get('downstreamboundarycapacityprofileset').get('downstreamboundarycapacityprofile'), (e) -> 
                                                    new $a.TreeChildItemView(e, "downstream-boundary-capacity-profiles")) if $w.get('downstreamboundarycapacityprofileset')?
    _.each($w.get('splitratioprofileset').get('splitratioprofile'), (e) -> new $a.TreeChildItemView(e, "split-ratio-profiles")) if $w.get('splitratioprofileset')?
    _.each($w.get('sensorlist').get('sensor'), (e) -> new $a.TreeChildItemView(e, "sensors")) if $w.get('sensorlist')?
    _.each($w.get('signallist').get('signal'), (e) -> new $a.TreeChildItemView(e, "signals")) if $w.get('signallist')?
    AppView.broker.trigger("app:tree")

    
