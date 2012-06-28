class window.sirius.MapSignalView extends window.sirius.MapMarkerView
  @view_sensors = []
     
  initialize: (model, lat_lng) ->
    super  model, lat_lng
    MapSignalView.view_signals.push @
    @broker.on('map:hide_signal_layer',@hide_marker(),@)
    @broker.on('map:show_signal_layer',@show_marker(),@)

  get_icon: ->
    super 'reddot'

