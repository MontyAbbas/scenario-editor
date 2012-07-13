# MapMarkerView is base class for scenario elements represented by a 
# single latitude and longitude on the Map
class window.sirius.MapMarkerView extends Backbone.View
  @IMAGE_PATH: '../libs/data/img/'
  $a = window.sirius
  
  initialize: (@model) ->
    self = @
    # get the position, we only draw if the position is defined
    # TODO deal with getting a position if it is not defined
    @latLng = $a.Util.getLatLng(model)
    @draw() 
    google.maps.event.addListener(@marker, 'dragend', @dragMarker())
    google.maps.event.addListener(@marker, 'click', (event) -> self.manageMarkerSelect())
    $a.broker.on('map:clear_selected', @clearSelected, @)
    $a.broker.on("map:select_item:#{@model.cid}", @makeSelected, @)
    $a.broker.on("map:clear_item:#{@model.cid}", @clearSelected, @)
    $a.broker.on('map:init', @render, @)
    $a.broker.on('map:clearMap', @removeAll, @)
    
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
  
  removeMarker: ->
  	@marker = null
  	
  removeAll: ->
  	@removeMarker()

  # Context Menu
  # Create the Marker Context Menu. This class is always called by it overridden subclass method.
  # The menu items are stored with their events in an array and
  # can be configired in the menu-data.coffee file. We create a dependency with the ContextMenuView
  # here. There may a better way to do this. I also add the contextMenu itself to the model so the
  # same menu can be added to the tree items for this node
  _contextMenu: (type, menuItems) ->
    @contextMenuOptions = {}
    @contextMenuOptions.class = 'context_menu'
    @contextMenuOptions.id = "context-menu-#{type}-#{@model.id}"
    @contextMenuOptions.menuItems = $a.Util.copy(menuItems)
    #set this id for the select item so we know what event to call
    self = @
    _.each(self.contextMenuOptions.menuItems, (item) -> item.id = "#{self.model.cid}")
    
    @contextMenu = new $a.ContextMenuView(@contextMenuOptions)
    self = @
    google.maps.event.addListener(@marker, 'rightclick', (mouseEvent) -> self.contextMenu.show mouseEvent.latLng )
    @model.set('contextMenu', @contextMenu)
    
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
  

