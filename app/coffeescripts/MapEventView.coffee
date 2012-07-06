# Creates events by overriding getIcon from MapMarkerView and registering
# show/hide events from the event layer. It also adds itself to and holds a static 
# array of events
class window.sirius.MapEventView extends window.sirius.MapMarkerView
  @ICON: 'event-deselected'
  @SELECTED_ICON: 'event-selected'
  @view_events = []
  $a = window.sirius
  
  initialize: (model, lat_lng) ->
    super model, lat_lng
    MapEventView.view_events.push @
    $a.broker.on('map:hide_event_layer', @hideMarker, @)
    $a.broker.on('map:show_event_layer', @showMarker, @)

  getIcon: ->
    super MapEventView.ICON

  ################# select events for marker
  # Callback for the markers click event
  markerSelect: () ->
    @_setIcon(MapEventView.ICON, MapEventView.SELECTED_ICON) 

  # Swaps icons depending on which icon is set
  _setIcon: (icon, selected) ->
    iconName = MapEventView.__super__._getIconName.apply(@, []) 
    if iconName == "#{icon}.png" 
      @marker.setIcon(MapEventView.__super__.getIcon.apply(@, [selected]) )
    else
      @marker.setIcon(MapEventView.__super__.getIcon.apply(@, [icon]) )

  # This method swaps the icon for the de-selected icon
  clearSelected: () =>
    super MapEventView.ICON unless $a.SHIFT_DOWN