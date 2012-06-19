class window.aurora.MapNodeView extends window.aurora.MapMarkerView
  @view_nodes = []

  initialize: (model,broker,lat_lng) ->
    super model,broker,lat_lng
    MapNodeView.view_nodes.push this
    this.broker.on('map:hide_node_layer',this.hide_marker(),this)
    this.broker.on('map:show_node_layer',this.show_marker(),this)

  get_icon: ->
    if this.model.get("type") != "T" then super 'dot' else super 'square'
