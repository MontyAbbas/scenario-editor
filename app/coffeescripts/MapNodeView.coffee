# Creates nodes by overriding get_icon from MapMarkerView and registering
# show/hide events from the node layer. It also adds itself to and holds a static 
# array of nodes
class window.sirius.MapNodeView extends window.sirius.MapMarkerView
  @view_nodes: []
  $a = window.sirius

  initialize: (model, lat_lng) ->
    super model, lat_lng
    MapNodeView.view_nodes.push @
    $a.broker.on('map:show_node_layer', @show_marker, @)
    $a.broker.on('map:hide_node_layer', @hide_marker, @)

  get_icon: ->
    if @model.get("type") != "terminal" then super 'dot' else super 'square'
