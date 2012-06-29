# Creates sensors by overriding get_icon from MapMarkerView and registering
# show/hide events from the sensors layer. It also adds itself to and holds a static 
# array of sensors
class window.sirius.MapSensorView extends window.sirius.MapMarkerView
  @view_sensors = []
  $a = window.sirius
  
  initialize: (model, lat_lng) ->
    super model, lat_lng
    MapSensorView.view_sensors.push @
    $a.AppView.broker.on('map:hide_sensor_layer', @hide_marker(), @)
    $a.AppView.broker.on('map:show_sensor_layer', @show_marker(), @)

  get_icon: ->
    super 'camera-orig' 

