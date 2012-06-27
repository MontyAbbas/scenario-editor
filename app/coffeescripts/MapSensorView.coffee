class window.sirius.MapSensorView extends window.sirius.MapMarkerView
  @view_sensors = []
     
  initialize: (model,broker,lat_lng) ->
    super  model,broker,lat_lng
    MapSensorView.view_sensors.push this
    @broker.on('map:hide_sensor_layer', @hide_marker(), @)
    @broker.on('map:show_sensor_layer', @show_marker(), @)

  get_icon: ->
    super 'camera-orig' 

