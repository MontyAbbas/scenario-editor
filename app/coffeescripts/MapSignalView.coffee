class window.sirius.MapSignalView extends window.sirius.MapMarkerView
  @view_sensors = []
     
  initialize: (model,broker,lat_lng) ->
    super  model,broker,lat_lng
    MapSignalView.view_signals.push this
    @broker.on('map:hide_signal_layer',@hide_marker(),this)
    @broker.on('map:show_signal_layer',@show_marker(),this)

  get_icon: ->
    super 'reddot'

