# Creates nodes by overriding getIcon from MapMarkerView and registering
# show/hide events from the node layer. It also adds itself to and holds a static 
# array of nodes
class window.sirius.MapNodeView extends window.sirius.MapMarkerView
  @ICON: 'dot'
  @SELECTED_ICON: 'reddot'
  @TERMINAL_ICON: 'square'
  @SELECTED_TERMINAL_ICON: 'red-square'
  @TERMINAL_TYPE: 'terminal'
  @view_nodes: []
  $a = window.sirius

  initialize: (model, lat_lng) ->
    super model, lat_lng
    MapNodeView.view_nodes.push @
    @_contextMenu()
    $a.broker.on('map:show_node_layer', @showMarker, @)
    $a.broker.on('map:hide_node_layer', @hideMarker, @)

  getIcon: ->
    super @_getTypeIcon false

  # Context Menu
  # Create the Node Context Menu. Call the super class method to create the context menu
  _contextMenu: () ->
    super 'node', $a.node_context_menu

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
  
      