class window.sirius.MapControllerView extends window.sirius.MapMarkerView
  @view_controllers = []
     
  initialize: (model,lat_lng) ->
    super  model, lat_lng
    MapControllerView.view_controllers.push @
    @broker.on('map:hide_controller_layer', @hide_marker(), @)
    @broker.on('map:show_controller_layer', @show_marker(), @)

  get_icon: ->
    super 'controller-deselected'

