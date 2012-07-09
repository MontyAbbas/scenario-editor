# ContextMenuView is creates context menus. It is heavily based off
# of the work done by Martin Pearman at http://code.martinpearman.co.uk/googlemapsapi/contextmenu/
# We ported most of it to jQuery, coffeesript and Backbone and abstracted to work for any context menu
# Notice it extends google's OverlayView. The specification requires onAdd, draw, and onRemove 
# to be overridden. See document on Google OverlayView for details on rendering:
# https://developers.google.com/maps/documentation/javascript/reference#OverlayView
class window.sirius.ContextMenuView extends google.maps.OverlayView
  $a = window.sirius
  el: {}
  
  constructor: (@options) ->
    @template = _.template($('#context-menu-template').html())
    @el =  @template({elemId: @options.id, elemClass: @options.class})
    @pixelOffset = @options.pixelOffset || new google.maps.Point(0, 0)
    @isVisible = false
    @position = new google.maps.LatLng(0, 0);
    #hides the context menu if you click anywhere else on the map
    self = @
    google.maps.event.addDomListener(window, 'click', (() -> self.hide()))

  
  draw: () ->
    if @isVisible
      mapSize = new google.maps.Size($("##{@options.id}").offsetWidth, $("##{@options.id}").offsetHeight)
      menuSize = new google.maps.Size($("##{@options.id}").offsetWidth, $("##{@options.id}").offsetHeight)
      mousePosition = @getProjection().fromLatLngToDivPixel(@position)
      left = mousePosition.x
      top = mousePosition.y

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
    @setMap(null)
    if @isVisible
      $("##{@options.id}").hide()
      @isVisible=false
  
  show: (position) ->
    $("body").append(@el)
    @position = position
    @setMap($a.map)
    if(!@isVisible)
      $("##{@options.id}").show()
      @isVisible = true

  onAdd: () ->
    self = @
    _.each(self.options.menuItems, (item) -> new $a.ContextMenuItemView(self.options.id, item))

  onRemove: () ->
    $("##{@options.id}").remove()
  
  getVisible: () ->
    @isVisible
