# Creates sensors by overriding getIcon from MapMarkerView and registering
# show/hide events from the sensors layer. It also adds itself to and holds a static 
# array of sensors
class window.sirius.MapSensorView extends window.sirius.MapMarkerView
  @ICON: 'camera-orig'
  @SELECTED_ICON: 'camera-selected'
  $a = window.sirius
  
  # we pass in the network links so the sensors can figure out which link they 
  # belong too 
  initialize: (model, links) ->
    super model
    @model.links = links
    @_contextMenu()
    $a.broker.on("map:select_neighbors:#{@model.cid}", @selectSelfandMyLinks, @)
    $a.broker.on("map:clear_neighbors:#{@model.cid}", @clearSelfandMyLinks, @)
    $a.broker.on('map:hide_sensor_layer', @hideMarker, @)
    $a.broker.on('map:show_sensor_layer', @showMarker, @)

  getIcon: ->
    super MapSensorView.ICON

  # This method overrides MapMarkerView to unpublish specific events to this type
  # and then calls super to set itself to null, unpublish the general events, and hide itself
  removeElement: =>
    $a.broker.off("map:select_neighbors:#{@model.cid}")
    $a.broker.off("map:clear_neighbors:#{@model.cid}")
    $a.broker.off('map:hide_sensor_layer')
    $a.broker.off('map:show_sensor_layer')
    super

  # Context Menu
  # Create the Sensor Context Menu. Call the super class method to create the context menu
  _contextMenu: () ->
    super 'sensor', $a.sensor_context_menu

  # Callback for the markers click event. It decided whether we are selecting or de-selecting and triggers appropriately 
  manageMarkerSelect: () =>
    iconName = MapSensorView.__super__._getIconName.apply(@, [])
    if iconName == "#{MapSensorView.ICON}.png"
      @_triggerClearSelectEvents()
      target = $a.Util.getElement(@model.get('link_reference').get('id'), @model.links)
      $a.broker.trigger("app:tree_highlight:#{target.cid}")
      @makeSelected()
    else
      @_triggerClearSelectEvents()
      @clearSelected() # you call clearSelected in case the Shift key is down and you are deselecting yourself

  # This function triggers the events that make the selected tree and map items to de-selected
  _triggerClearSelectEvents: () ->
    $a.broker.trigger('map:clear_selected') unless $a.SHIFT_DOWN
    $a.broker.trigger('app:tree_remove_highlight') unless $a.SHIFT_DOWN

  # This method is called from the context menu and selects itself and all the sensor links.
  # Note we filter the Network links for all links with this node attached.
  selectSelfandMyLinks: () ->
    @_triggerClearSelectEvents()
    @makeSelected()
    self = @
    links =  _.filter($a.MapNetworkModel.LINKS, (link) -> link.get('id') == self.model.get('link_reference').get('id'))
    _.each(links, (link) -> 
        $a.broker.trigger("app:tree_highlight:#{link.cid}")
        $a.broker.trigger("map:select_item:#{link.cid}")
      )

  # This method is called from the context menu and de-selects itself and all the sensor links.
  # Note we filter the Network links for all links with this node attached.
  clearSelfandMyLinks: () ->
    @clearSelected()
    self = @
    links =  _.filter($a.MapNetworkModel.LINKS, (link) -> link.get('id') == self.model.get('link_reference').get('id'))
    _.each(links, (link) -> 
        $a.broker.trigger("map:clear_item:#{link.cid}")
        $a.broker.trigger("app:tree_remove_highlight:#{link.cid}")
      )
      
  # This method swaps the icon for the selected icon
  makeSelected: () ->
    super MapSensorView.SELECTED_ICON

  # This method swaps the icon for the de-selected icon
  clearSelected: () =>
    super MapSensorView.ICON
    


