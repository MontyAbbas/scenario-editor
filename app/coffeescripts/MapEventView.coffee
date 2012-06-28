class window.sirius.MapEventView extends window.sirius.MapMarkerView
  @view_events = []
     
  initialize: (model,broker,lat_lng) ->
    super  model,broker,lat_lng
    MapEventView.view_events.push this
    @broker.on('map:hide_event_layer',@hide_marker(),this)
    @broker.on('map:show_event_layer',@show_marker(),this)

  get_icon: ->
    super 'event-deselected'

