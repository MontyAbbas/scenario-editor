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
  
  # Reset the static array
  removeAll: ->
    @removeMarker()
    @view_signals = []
    
  ################# select events for marker
  # Callback for the markers click event. It decided whether we are selecting or de-selecting and triggers appropriately 
  manageMarkerSelect: () =>
    iconName = MapSignalView.__super__._getIconName.apply(@, []) 
    if iconName == "#{MapSignalView.ICON}.png"
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

  # This method is called from the context menu and selects itself and all the nodes links.
  # Note we filter the Network links for all links with this node attached. The inputs and
  # output can be used in the future but test data was not configured correctly
  selectSelfandMyLinks: () ->
    @makeSelected()
    self = @
    links =  _.filter($a.MapNetworkModel.LINKS, (link) -> link.get('id') == self.model.get('link_reference').get('id'))
    _.each(links, (link) -> $a.broker.trigger("map:select_item:#{link.cid}"))

  # This method swaps the icon for the selected icon
  makeSelected: () ->
    super MapSignalView.SELECTED_ICON

  # This method swaps the icon for the de-selected icon
  clearSelected: () =>
    super MapSignalView.ICON