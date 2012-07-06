# Creates contollers by overriding getIcon from MapMarkerView and registering
# show/hide events from the controller layer. It also adds itself to and holds a static 
# array of controllers  
class window.sirius.MapControllerView extends window.sirius.MapMarkerView
  @ICON: 'controller-deselected'
  @SELECTED_ICON: 'controller-selected'
  @view_controllers = []
  $a = window.sirius

  initialize: (model,lat_lng) ->
    super  model, lat_lng
    MapControllerView.view_controllers.push @
    $a.broker.on('map:hide_controller_layer', @hideMarker, @)
    $a.broker.on('map:show_controller_layer', @showMarker, @)

  getIcon: ->
    super MapControllerView.ICON

  ################# select events for marker
  # Callback for the markers click event
  markerSelect: () ->
    @_setIcon(MapControllerView.ICON, MapControllerView.SELECTED_ICON) 

  # Swaps icons depending on which icon is set
  _setIcon: (icon, selected) ->
    iconName = MapControllerView.__super__._getIconName.apply(@, []) 
    if iconName == "#{icon}.png" 
      @marker.setIcon(MapControllerView.__super__.getIcon.apply(@, [selected]) )
    else
      @marker.setIcon(MapControllerView.__super__.getIcon.apply(@, [icon]) )