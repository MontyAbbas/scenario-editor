# MapMarkerView is base class for scenario elements represented by a 
# single latitude and longitude on the Map
class window.sirius.MapMarkerView extends Backbone.View
  @IMAGE_PATH: '../libs/data/img/'
  $a = window.sirius
  
  initialize: (@model, @latLng) ->
    self = @
    @draw()
    google.maps.event.addListener(@marker, 'dragend', @dragMarker())
    google.maps.event.addListener(@marker, 'click', (event) -> self.manageMarkerSelect())
    $a.broker.on('map:clear_selected', @clearSelected, @)
    $a.broker.on("map:select_item:#{@model.cid}", @manageMarkerSelect, @)
    $a.broker.on('map:init', @render, @)

  render: =>
    @marker.setMap($a.map)
    @

  # Draw the marker by determining the type of icon
  # is used for each type of element. The default is the 
  # our standard dot.png. Each subclasses overrides get_icon
  # to pass the correct icon 
  draw: ->
    @marker = new google.maps.Marker({
        map: null
        position: @latLng 
        draggable: true
        icon: @getIcon()
        title: "Name: #{@model.get('name')}\nLatitude: #{@latLng.lat()}\nLongitude: #{@latLng.lng()}"
      });
    
  
  getIcon: (img) ->
    @getMarkerImage img
  
  getMarkerImage: (img) ->
    new google.maps.MarkerImage("#{MapMarkerView.IMAGE_PATH}#{img}.png",
      new google.maps.Size(32, 32),
      new google.maps.Point(0,0),
      new google.maps.Point(16, 16)
    );

  # Context Menu
  # Create the Marker Context Menu. This class is always called by it overridden subclass method.
  # The menu items are stored with their events in an array and
  # can be configired in the menu-data.coffee file
  _contextMenu: (type, menuItems) ->
    contextMenuOptions = {}
    contextMenuOptions.menuItems = menuItems
    contextMenuOptions.class = 'context_menu'
    contextMenuOptions.id = "context-menu-#{type}-#{@model.id}"
    $a.contextMenu = new $a.ContextMenuView(contextMenuOptions)
    google.maps.event.addListener(@marker, 'rightclick', (mouseEvent) -> $a.contextMenu.show mouseEvent.latLng )

  # events used to move the marker and update its position
  dragMarker: =>
    @latLng = @marker.getPosition();
    $a.map.panTo(@latLng);
  
  ################# The following handles the show and hide of node layers
  hideMarker: =>
    @marker.setMap(null)

  showMarker: =>
    @marker.setMap($a.map)

  # Used by subclasses to get name of image in order to swap between selected and not selected
  _getIconName: () ->
    tokens = @marker.get('icon').url.split '/'
    lastIndex =  tokens.length - 1
    tokens[lastIndex]
  
  _setSelected: (img) ->
    @marker.setIcon(@getMarkerImage(img))
      
  # This method swaps the icon for the selected icon
  makeSelected: (img) ->
    @_setSelected img
  
  # This method swaps the icon for the de-selected icon
  clearSelected: (img) ->
    @_setSelected img
  

