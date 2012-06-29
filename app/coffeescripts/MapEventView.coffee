# Creates events by overriding get_icon from MapMarkerView and registering
# show/hide events from the event layer. It also adds itself to and holds a static 
# array of events
class window.sirius.MapEventView extends window.sirius.MapMarkerView
  @view_events = []
  $a = window.sirius
  
  initialize: (model, lat_lng) ->
    super model, lat_lng
    MapEventView.view_events.push @
    $a.AppView.broker.on('map:hide_event_layer',@hide_marker(),@)
    $a.AppView.broker.on('map:show_event_layer',@show_marker(),@)

  get_icon: ->
    super 'event-deselected'

