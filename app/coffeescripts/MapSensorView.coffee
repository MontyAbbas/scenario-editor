# Creates sensors by overriding getIcon from MapMarkerView and registering
# show/hide events from the sensors layer. It also adds itself to and holds a static 
# array of sensors
class window.sirius.MapSensorView extends window.sirius.MapMarkerView
  @ICON: 'camera-orig'
  @SELECTED_ICON: 'camera-selected'
  @view_sensors = []
  $a = window.sirius
  
  initialize: (model, lat_lng) ->
    super model, lat_lng
    MapSensorView.view_sensors.push @
    $a.broker.on('map:hide_sensor_layer', @hideMarker, @)
    $a.broker.on('map:show_sensor_layer', @showMarker, @)

  getIcon: ->
    super MapSensorView.ICONMapSensorView

  ################# select events for marker
  # Callback for the markers click event
  markerSelect: () ->
    $a.broker.trigger('map:clear_selected')
    @_setIcon(MapSensorView.ICON, MapSensorView.SELECTED_ICON) 

  # Swaps icons depending on which icon is set
  _setIcon: (icon, selected) ->
    iconName = MapSensorView.__super__._getIconName.apply(@, []) 
    if iconName == "#{icon}.png" 
      @marker.setIcon(MapSensorView.__super__.getIcon.apply(@, [selected]) )
    else
      @marker.setIcon(MapSensorView.__super__.getIcon.apply(@, [icon]) )

  # This method swaps the icon for the de-selected icon
  clearSelected: () =>
    super MapSensorView.ICON unless $a.SHIFT_DOWN