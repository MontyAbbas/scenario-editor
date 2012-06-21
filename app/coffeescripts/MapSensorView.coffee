class window.sirius.MapSensorView extends window.sirius.MapMarkerView
  @view_sensors = []
     
  initialize: (model,broker,lat_lng) ->
    super  model,broker,lat_lng
    MapSensorView.view_sensors.push this
    this.broker.on('map:hide_sensor_layer',this.hide_marker(),this)
    this.broker.on('map:show_sensor_layer',this.show_marker(),this)

  get_icon: ->
    super 'camera-orig' 

