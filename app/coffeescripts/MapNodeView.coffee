# Creates nodes by overriding get_icon from MapMarkerView and registering
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
    $a.broker.on('map:show_node_layer', @showMarker, @)
    $a.broker.on('map:hide_node_layer', @hideMarker, @)

  getIcon: ->
    if @model.get('type') != MapNodeView.TERMINAL_TYPE then super MapNodeView.ICON else super MapNodeView.TERMINAL_ICON

  marker_select: () ->

    if @model.get('type') != MapNodeView.TERMINAL_TYPE
      @_setIcon(MapNodeView.ICON, MapNodeView.SELECTED_ICON) 
    else
      @_setIcon(MapNodeView.TERMINAL_ICON, MapNodeView.SELECTED_TERMINAL_ICON)
  
  _setIcon: (icon, selected) ->
    iconName = @_getIconName()
    if iconName == "#{icon}.png" 
      @marker.setIcon(MapNodeView.__super__.getIcon.apply(@, [selected]) )
    else
      @marker.setIcon(MapNodeView.__super__.getIcon.apply(@, [icon]) )
    
  _getIconName: () ->
    tokens = @marker.get('icon').url.split "/"
    lastIndex =  tokens.length - 1
    tokens[lastIndex]
    