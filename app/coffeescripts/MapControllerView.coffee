class window.sirius.MapControllerView extends window.sirius.MapMarkerView
  @view_controllers = []
     
  initialize: (model,broker,lat_lng) ->
    super  model,broker,lat_lng
    MapControllerView.view_controllers.push this
    @broker.on('map:hide_controller_layer', @hide_marker(), this)
    @broker.on('map:show_controller_layer', @show_marker(), this)

  get_icon: ->
    super 'controller-deselected'

