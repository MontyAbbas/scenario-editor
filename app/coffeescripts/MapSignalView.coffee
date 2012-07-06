# Creates signals by overriding getIcon from MapMarkerView and registering
# show/hide events from the signals layer. It also adds itself to and holds a static 
# array of signals
class window.sirius.MapSignalView extends window.sirius.MapMarkerView
  @ICON: 'green-triangle'
  @SELECTED_ICON: 'red-triangle'
  @view_signals = []
  $a = window.sirius

  initialize: (model, lat_lng) ->
    super  model, lat_lng
    MapSignalView.view_signals.push @
    $a.broker.on('map:hide_signal_layer', @hideMarker, @)
    $a.broker.on('map:show_signal_layer', @showMarker, @)

  getIcon: ->
    super MapSignalView.ICON
    
  ################# select events for marker
  # Callback for the markers click event
  markerSelect: () ->
    $a.broker.trigger('map:clear_selected')
    @_setIcon(MapSignalView.ICON, MapSignalView.SELECTED_ICON) 

  # Called by markerSelect : swaps icons depending on which icon is set
  _setIcon: (icon, selected) ->
    iconName = MapSignalView.__super__._getIconName.apply(@, []) 
    if iconName == "#{icon}.png" 
      @marker.setIcon(MapSignalView.__super__.getIcon.apply(@, [selected]) )
    else
      @marker.setIcon(MapSignalView.__super__.getIcon.apply(@, [icon]) )

  # This method swaps the icon for the de-selected icon
  clearSelected: () =>
    super MapSignalView.ICON unless $a.SHIFT_DOWN