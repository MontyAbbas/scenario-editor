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
    @model.scenElements = @model.get('targetelements').get('scenarioelement')
    @model.links = @_getLinks()
    MapControllerView.view_controllers.push @
    $a.broker.on('map:hide_controller_layer', @hideMarker, @)
    $a.broker.on('map:show_controller_layer', @showMarker, @)

  getIcon: ->
    super MapControllerView.ICON

  # Reset the static array
  @removeAll: ->
    @view_controllers = []

  ################# select events for marker
  # Callback for the markers click event
  # Callback for the markers click event. It decided whether we are selecting or de-selecting and triggers appropriately 
  manageMarkerSelect: () =>
    iconName = MapControllerView.__super__._getIconName.apply(@, []) 
    if iconName == "#{MapControllerView.ICON}.png"
      @_triggerClearSelectEvents()
      $a.broker.trigger("app:tree_highlight:#{@model.cid}")
      @makeSelected()
    else
      @_triggerClearSelectEvents()
      @clearSelected() # you call clearSelected in case the Shift key is down and you are deselecting yourself

  # This function triggers the events that make the selected tree and map items to de-selected
  _triggerClearSelectEvents: () ->
    $a.broker.trigger('map:clear_selected') unless $a.SHIFT_DOWN
    $a.broker.trigger('app:tree_remove_highlight') unless $a.SHIFT_DOWN

  # This method swaps the icon for the selected icon
  makeSelected: () ->
    self = @
    _.each(self.model.links, (link) -> 
          $a.broker.trigger("map:select_item:#{link.cid}")
          $a.broker.trigger("app:tree_highlight:#{link.cid}")
        )
    super MapControllerView.SELECTED_ICON

  # This method swaps the icon for the de-selected icon
  clearSelected: () =>
    super MapControllerView.ICON

  # Iterate over the list to find name associated with the id
  _getLinks: ->
    links = []
    self = @
    _.each(self.model.scenElements, (elem) -> links.push $a.Util.getElement(elem.id,$a.MapNetworkModel.LINKS))
    links