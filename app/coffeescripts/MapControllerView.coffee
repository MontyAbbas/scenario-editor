# Creates contollers by overriding get_icon from MapMarkerView and registering
# show/hide events from the controller layer. It also adds itself to and holds a static 
# array of controllers  
class window.sirius.MapControllerView extends window.sirius.MapMarkerView
  @view_controllers = []
  $a = window.sirius

  initialize: (model,lat_lng) ->
    super  model, lat_lng
    MapControllerView.view_controllers.push @
    $a.broker.on('map:hide_controller_layer', @hide_marker, @)
    $a.broker.on('map:show_controller_layer', @show_marker, @)

  get_icon: ->
    super 'controller-deselected'

