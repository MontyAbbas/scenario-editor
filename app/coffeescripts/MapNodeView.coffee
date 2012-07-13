# Creates nodes by overriding getIcon from MapMarkerView and registering
# show/hide events from the node layer. It also adds itself to and holds a static 
# array of nodes
class window.sirius.MapNodeView extends window.sirius.MapMarkerView
  @ICON: 'dot'
  @SELECTED_ICON: 'reddot'
  @TERMINAL_ICON: 'square'
  @SELECTED_TERMINAL_ICON: 'red-square'
  @TERMINAL_TYPE: 'terminal'
  $a = window.sirius

  initialize: (model) ->
    super model
    @_contextMenu()
    $a.broker.on("map:select_neighbors:#{@model.cid}", @selectSelfandMyLinks, @)
    $a.broker.on("map:select_neighbors_outgoing:#{@model.cid}", @selectMyLinks, @)
    $a.broker.on("map:select_neighbors_incoming:#{@model.cid}", @selectMyLinks, @)
    $a.broker.on("map:clear_neighbors:#{@model.cid}", @clearSelfandMyLinks, @)
    $a.broker.on('map:show_node_layer', @showMarker, @)
    $a.broker.on('map:hide_node_layer', @hideMarker, @)
    $a.broker.on("map:nodes:show_#{@model.get('type')}", @showMarker, @)
    $a.broker.on("map:nodes:hide_#{@model.get('type')}", @hideMarker, @)
    
    
  getIcon: ->
    super @_getTypeIcon false

  # Context Menu
  # Create the Node Context Menu. Call the super class method to create the context menu
  _contextMenu: () ->
    super 'node', $a.node_context_menu

  # This method overrides MapMarkerView to unpublish specific events to this type
  # and then calls super to set itself to null, unpublish the general events, and hide itself
  removeElement: =>
    $a.broker.off("map:select_neighbors:#{@model.cid}")
    $a.broker.off("map:select_neighbors_outgoing:#{@model.cid}")
    $a.broker.off("map:select_neighbors_incoming:#{@model.cid}")
    $a.broker.off("map:clear_neighbors:#{@model.cid}")
    $a.broker.off('map:show_node_layer')
    $a.broker.off('map:hide_node_layer')
    $a.broker.off("map:nodes:show_#{@model.get('type')}")
    $a.broker.off("map:nodes:hide_#{@model.get('type')}")
    super

  ################# select events for marker
  # Callback for the markers click event. It decided whether we are selecting or de-selecting and triggers appropriately 
  manageMarkerSelect: () =>
    iconName = MapNodeView.__super__._getIconName.apply(@, []) 
    if iconName == "#{@_getTypeIcon(false)}.png"
      @_triggerClearSelectEvents()
      $a.broker.trigger("app:tree_highlight:#{@model.cid}")
      @makeSelected()
    else
      @_triggerClearSelectEvents()
      @clearSelected() # you call clearSelected in case the Shift key is down and you are deselecting yourself
  
  # This function triggers the events that make the selected tree and map items to de-selected
  _triggerClearSelectEvents: () ->
    $a.broker.trigger('map:clear_selected') unless $a.SHIFT_DOWN
    $a.broker.trigger('app:tree_remove_highlight') unless $a.SHIFT_DOWN
  
  # This method is called from the context menu and selects itself and all the nodes links.
  # Note: The links references are from the output and input attributes on the node. 
  selectSelfandMyLinks: () ->
    # de-select everything unless SHIFT is down
    @_triggerClearSelectEvents()
    @makeSelected()
    $a.broker.trigger("app:tree_highlight:#{@model.cid}")
    self = @
    _.each(['input','output'], (type) -> 
        _.each(self._getInputOrOutputLinks(type), (link) -> 
          $a.broker.trigger("map:select_item:#{link.get('link').cid}")
          $a.broker.trigger("app:tree_highlight:#{link.get('link').cid}")
        )
    )

  # This method is called from the context menu and clears itself and all the nodes links.
  # Note: The links references are from the output and input attributes on the node. 
  clearSelfandMyLinks: () ->
    @clearSelected()
    $a.broker.trigger("app:tree_remove_highlight:#{@model.cid}")
    self = @
    _.each(['input','output'], (type) -> 
        _.each(self._getInputOrOutputLinks(type), (link) -> 
              $a.broker.trigger("map:clear_item:#{link.get('link').cid}")
              $a.broker.trigger("app:tree_remove_highlight:#{link.get('link').cid}")
        )
      )
  
  # This method is called from the context menu to select this nodes output or input links.
  # The type parameter determins whether we are grabbing output or input attributes on the node. 
  selectMyLinks: (type) ->
    # de-select everything unless SHIFT is down
    @_triggerClearSelectEvents()
    self = @
    _.each(self._getInputOrOutputLinks(type), (link) -> 
        $a.broker.trigger("map:select_item:#{link.get('link').cid}")
        $a.broker.trigger("app:tree_highlight:#{link.get('link').cid}")
      )

  _getInputOrOutputLinks: (type) ->
    @model.get("#{type}s").get("#{type}")
    
  # This method swaps the icon for the selected icon
  makeSelected: () ->
    super @_getTypeIcon true
  
  # This method swaps the icon for the de-selected icon
  clearSelected: () =>
    super @_getTypeIcon false
  
  # This returns the appropriate icon for terminals and selected or not
  _getTypeIcon : (selected) ->
    switch @model.get('type') 
      when MapNodeView.TERMINAL_TYPE 
        if selected
          MapNodeView.SELECTED_TERMINAL_ICON
        else
          MapNodeView.TERMINAL_ICON
      else 
        if selected
          MapNodeView.SELECTED_ICON
        else
          MapNodeView.ICON
  
      
