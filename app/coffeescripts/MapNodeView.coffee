class window.sirius.MapNodeView extends window.sirius.MapMarkerView
  @view_nodes = []

  initialize: (model, broker, lat_lng) ->
    super model, broker, lat_lng
    MapNodeView.view_nodes.push this
    @broker.on('map:hide_node_layer', @hide_marker(), @)
    @broker.on('map:show_node_layer', @show_marker(), @)

  get_icon: ->
    if @model.get("type") != "terminal" then super 'dot' else super 'square'
