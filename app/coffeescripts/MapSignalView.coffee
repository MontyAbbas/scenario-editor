# Creates signals by overriding get_icon from MapMarkerView and registering
# show/hide events from the signals layer. It also adds itself to and holds a static 
# array of signals
class window.sirius.MapSignalView extends window.sirius.MapMarkerView
  @view_signals = []
  $a = window.sirius

  initialize: (model, lat_lng) ->
    super  model, lat_lng
    MapSignalView.view_signals.push @
    $a.broker.on('map:hide_signal_layer', @hide_marker, @)
    $a.broker.on('map:show_signal_layer', @show_marker, @)

  get_icon: ->
    super 'reddot'

