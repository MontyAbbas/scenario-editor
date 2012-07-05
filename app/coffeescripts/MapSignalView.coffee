# Creates signals by overriding get_icon from MapMarkerView and registering
# show/hide events from the signals layer. It also adds itself to and holds a static 
# array of signals
class window.sirius.MapSignalView extends window.sirius.MapMarkerView
  @view_sensors = []
  $a = window.sirius

  initialize: (model, lat_lng) ->
    super  model, lat_lng
    MapSignalView.view_signals.push @
    $a.broker.on('map:hide_signal_layer', @hide_marker, @)
    $a.broker.on('map:show_signal_layer', @show_marker, @)

  get_icon: ->
    super 'reddot'
    
  ################# select events for marker
  marker_select: () ->
    console.log @marker.get('icon')
    # if @marker.get('icon') == MapLinkView.LINK_COLOR
    #   @marker.setOptions(options: { strokeColor: MapLinkView.SELECTED_LINK_COLOR })
    # else
    #   @link.setOptions(options: { strokeColor: MapLinkView.LINK_COLOR })

