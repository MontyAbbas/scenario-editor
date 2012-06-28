@class window.sirius.MapEventView extends window.sirius.MapMarkerView
  @view_events = []

  initialize: (model, lat_lng) ->
    super model, lat_lng
    MapEventView.view_events.push @
    @broker.on('map:hide_event_layer',@hide_marker(),@)
    @broker.on('map:show_event_layer',@show_marker(),@)

  get_icon: ->
    super 'event-deselected'

