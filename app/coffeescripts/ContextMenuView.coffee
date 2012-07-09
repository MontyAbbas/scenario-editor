# ContextMenuView is creates context menus. It is heavily based off
# of the work done by Martin Pearman at http://code.martinpearman.co.uk/googlemapsapi/contextmenu/
# We ported most of it to jQuery, coffeesript and Backbone and abstracted to work for any context menu
# Notice it extends google's OverlayView. The specification requires onAdd, draw, and onRemove 
# to be overridden. See document on Google OverlayView for details on rendering:
# https://developers.google.com/maps/documentation/javascript/reference#OverlayView
class window.sirius.ContextMenuView extends google.maps.OverlayView
  $a = window.sirius
  
  constructor: (@options) ->
    @pixelOffset = @options.pixelOffset || new google.maps.Point(0, 0)
    @isVisible = false
    @position = new google.maps.LatLng(0, 0);
    @setMap($a.map)
    #hides the context menu if you click anywhere else on the map
    self = @
    google.maps.event.addDomListener(window, 'click', (() -> self.hide()))

  
  draw: () ->
    if @isVisible
      mapSize=new google.maps.Size($("##{@options.id}").offsetWidth, $("##{@options.id}").offsetHeight)
      menuSize=new google.maps.Size($("##{@options.id}").offsetWidth, $("##{@options.id}").offsetHeight)
      mousePosition=@getProjection().fromLatLngToDivPixel(@position)
      left=mousePosition.x
      top=mousePosition.y

      if(mousePosition.x>mapSize.width-menuSize.width-@pixelOffset.x)
        left=left-menuSize.width-@pixelOffset.x
      else
        left+=@pixelOffset.x

      if(mousePosition.y>mapSize.height-menuSize.height-@pixelOffset.y)
        top=top-menuSize.height-@pixelOffset.y
      else
        top+=@pixelOffset.y
      
      $("##{@options.id}").css({ top: "#{top}px", left: "#{left}px"})
  
  hide: () ->
    if @isVisible
      $("##{@options.id}").hide()
      @isVisible=false
  
  show: (position) ->
    if(!@isVisible)
      $("##{@options.id}").show()
      @isVisible = true
    @position = position
    @draw()
  
  onAdd: () ->
    @menu = $("##{@options.id}")[0]
    self = @
    _.each(self.options.menuItems, (item) -> new $a.ContextMenuItemView(self, item))
    @getPanes().floatPane.appendChild(@menu)

  onRemove: () ->
    @menu.parentNode.removeChild(@menu)
  
  getVisible: () ->
    @isVisible
