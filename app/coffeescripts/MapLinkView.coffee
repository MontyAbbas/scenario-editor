# Creates the links of the network. A link consists of a
# Polyline drawn between two steps in the route as well as
# an arrow head pointing in the appropriate direction if the 
# Polyline is sufficiently long. 
class window.sirius.MapLinkView extends Backbone.View
  @LINK_COLOR: 'blue'
  @SELECTED_LINK_COLOR: 'red'
  
  @view_links = []
  $a = window.sirius

  initialize: (@model, @legs) ->
    self = @
    @drawLink @legs
    #@drawArrow @leg
    MapLinkView.view_links.push @
    @_contextMenu()
    $a.broker.on('map:init', @render, @)
    $a.broker.on('map:hide_link_layer', @hideLink, @)
    $a.broker.on('map:show_link_layer', @showLink, @)
    $a.broker.on("map:links:show_#{@model.get('type')}", @showLink, @)
    $a.broker.on("map:links:hide_#{@model.get('type')}", @hideLink, @)
    $a.broker.on("map:select_item:#{@model.cid}", @linkSelect, @)
    $a.broker.on("map:clear_item:#{@model.cid}", @clearSelected, @)
    $a.broker.on("map:select_neighbors:#{@model.cid}", @selectSelfandMyNodes, @)
    $a.broker.on("map:clear_neighbors:#{@model.cid}", @clearSelfandMyNodes, @)
    google.maps.event.addListener(@link, 'click', (event) -> self.manageLinkSelect())
    $a.broker.on('map:clear_selected', @clearSelected, @)
    $a.broker.on("map:clearMap", @removeAll, @)
  
  render: =>
    @link.setMap($a.map)
    #@arrow.setMap($a.map) if @arrow?
    @

  # Reset the static array
  removeAll: ->
    #$a.broker.off('map:show_link_layer', @showLink, @)
    @link = null
    @view_links = []

  #this method reads the path of points contained in the leg
  #and converts it into a polyline object to be drawn on the map
  #The Polyline map attribute will be null until render is called
  drawLink: (legs) ->
    sm_path = []
    for leg in legs
      for step in leg.steps
        for pt in step.path
          if !(pt in sm_path)
            sm_path.push pt
          
    @link = new google.maps.Polyline({
      path: sm_path
      map: $a.map
      strokeColor:  MapLinkView.LINK_COLOR
      icons: [{
          icon: { path: google.maps.SymbolPath.FORWARD_OPEN_ARROW } 
          #icon: {path : 'M0 0,4 0,3 5,z'} # manually vectorized
          fillColor: 'blue'
          offset: '50%'
        }]
      strokeOpacity: 0.6
      strokeWeight: 4
    })
    
  # Context Menu
  # Create the link Context Menu. The menu items are stored with their events in an array and
  # con be configired in the menu-data.coffee file.  We create a dependency with the ContextMenuView
  # here. There may a better way to do this. I also add the contextMenu itself to the model so the
  # same menu can be added to the tree items for this link
  _contextMenu: () ->
    @contextMenuOptions = {}
    @contextMenuOptions.menuItems = []
    @contextMenuOptions.menuItems = $a.Util.copy($a.link_context_menu)
    #set this id for the select item so we know what event to call
    self = @
    _.each(self.contextMenuOptions.menuItems, (item) -> item.id = "#{self.model.cid}")
    @contextMenuOptions.class = 'context_menu'
    @contextMenuOptions.id = "context-menu-link-#{@model.cid}"
    @contextMenu = new $a.ContextMenuView(@contextMenuOptions)
    self = @
    google.maps.event.addListener(@link, 'rightclick', (mouseEvent) -> self.contextMenu.show mouseEvent.latLng )
    @model.set('contextMenu', @contextMenu)

  ################# The following handles the show and hide of link layers including the arrow heads
  hideLink: () ->
    @link.setMap(null)
    #@arrow.setMap(null) if @arrow?
  
  showLink: () =>
    @link.setMap($a.map)
    #@arrow.setMap($a.map) if @arrow?

  # Select events for link
  # Unless the Shift key is held down, this function clears any other selected items on the map and in the tree after 
  # we determine if this link is to be selected or deselected. You need to call @_triggerClearSelectEvents from within
  # the conditional so that you appropriately select or de-select the current link and corresponding tree item
  manageLinkSelect: () ->
    if @link.get('strokeColor') == MapLinkView.LINK_COLOR
      @_triggerClearSelectEvents()
      $a.broker.trigger("app:tree_highlight:#{@model.cid}")
      @linkSelect()
    else
      @_triggerClearSelectEvents()
      @clearSelected()

  # This function triggers the events that make the selected tree and map items to de-selected
  _triggerClearSelectEvents: () ->
    $a.broker.trigger('map:clear_selected') unless $a.SHIFT_DOWN
    $a.broker.trigger('app:tree_remove_highlight') unless $a.SHIFT_DOWN
   
  # This method swaps the icon for the selected color
  linkSelect: () ->
    @link.setOptions(options: { strokeColor: MapLinkView.SELECTED_LINK_COLOR })
    
  # This method swaps the icon for the de-selected color
  clearSelected: () =>
    @link.setOptions(options: { strokeColor: MapLinkView.LINK_COLOR })
  
  # This method is called from the context menu and selects itself and all the links nodes as the higlighted tree items
  selectSelfandMyNodes: () ->
    # First see if everthing should be de-selected -- if shift is down will not occur
    @_triggerClearSelectEvents()
    @linkSelect()
    $a.broker.trigger("app:tree_highlight:#{@model.cid}")
    $a.broker.trigger("app:tree_highlight:#{@model.get("begin").get("node").cid}")
    $a.broker.trigger("app:tree_highlight:#{@model.get("end").get("node").cid}")
    $a.broker.trigger("map:select_item:#{@model.get("begin").get("node").cid}")
    $a.broker.trigger("map:select_item:#{@model.get("end").get("node").cid}")

  # called from the context menu as well. It clears itself and its nodes as well as the higlighted tree items
  clearSelfandMyNodes: () ->
    @clearSelected()
    $a.broker.trigger("map:clear_item:#{@model.get("begin").get("node").cid}")
    $a.broker.trigger("map:clear_item:#{@model.get("end").get("node").cid}")
    $a.broker.trigger("app:tree_remove_highlight:#{@model.cid}")
    $a.broker.trigger("app:tree_remove_highlight:#{@model.get("begin").get("node").cid}")
    $a.broker.trigger("app:tree_remove_highlight:#{@model.get("end").get("node").cid}")

  
  ################# manually drawing arrow 
  # NOTE : I am removing this for now in favor of the v3 method of using symbol paths. 
  #        The downside to predefined symbol paths is that they scale to strokeWeight of polyline
  #        But the color changes correctly. When use the method below we can not change the arrow color
  #        The ultimate solution would be to draw the vector image of the arrow ourselves using vector path
  
  # #Arrow Positoning calculations involve the following functions:
  # #displayArrow, getArrowStep, getArrowPositionIndex, and getAngleOfArrow
  # #setUprrow calcuates the position and angle of the arrow to display along the route
  # drawArrow: () ->
  #   #get the step along the route is about halfway
  #   arrow_step = @getArrowStep(@leg)
  #   #get the index of the latitude/longitude that is about halfway through the step
  #   lat_lng_index = @getArrowPositionIndex(arrow_step)
  #   #get the arrows lat/lng from the path
  #   #It would be better to get the exact midpoint of the line using something like this:
  #   #google.maps.geometry.spherical.interpolate(legs[0].start_location, legs[0].end_location, .5)
  #   #The problem here is that this calculates the lat/lng midpoint of straight line between the points -- not along the route
  #   arrow_lat_lng_pos = arrow_step.path[lat_lng_index] 
  #   #angle the arrow towards this lat_lng - we only draw arrow if more than 2 steps
  #   arrow_angle_to = arrow_step.path[lat_lng_index + 1]
  #   
  #   #if the route has less than 2 steps than don't draw arrow
  #   @arrow = null
  #   if arrow_step.path.length > 2
  #     #calculate direction of arrow
  #     dir = @getAngleOfArrow(arrow_lat_lng_pos,arrow_angle_to)
  #     self = this
  #     @arrow = new google.maps.Marker({
  #       position: arrow_lat_lng_pos,
  #       icon: new google.maps.MarkerImage('http://maps.google.com/mapfiles/dir_'+dir+'.png',
  #                   new google.maps.Size(24,24),
  #                   new google.maps.Point(0,0),
  #                   new google.maps.Point(12,12)
  #             ),
  #       map: $a.map
  #     });
  # 
  # #this moves through the steps array of the route to determine which step is about 
  # #halfway through the leg
  # getArrowStep: (leg) ->
  #   steps = leg.steps
  #   total_meters = 0
  #   for step,index in steps
  #     total_meters += step.distance.value
  #     arrow_step = step
  #     if(total_meters >= leg.distance.value / 2)
  #       break
  # 
  #   arrow_step
  # 
  # #for the step parameter get the index of the middle
  # #lat/lng
  # getArrowPositionIndex: (step) ->
  #   Math.floor(step.path.length / 2)
  # 
  # #this uses google spherical geometry functions to calculate the heading if our arrow.
  # getAngleOfArrow: (pos, towards) ->
  #   dir = google.maps.geometry.spherical.computeHeading(pos, towards).toFixed(1);
  #   #round it to a multiple of 3 and correct unusable numbers
  #   dir = Math.round(dir/3) * 3;
  #   if (dir < 0)
  #     dir += 240
  #   if (dir > 117) 
  #     dir -= 120
  #   dir