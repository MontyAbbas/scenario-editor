class window.sirius.MapLinkView extends Backbone.View
  @view_links = []
  
  initialize: (leg, broker) ->
    this.leg = leg
    this.drawLink leg
    this.drawArrow leg
    this.broker = broker
    MapLinkView.view_links.push this
    this.broker.on('map:init', this.render(), this)
    this.broker.on('map:hide_link_layer',this.hide_link(),this)
    this.broker.on('map:show_link_layer',this.show_link(),this)
    
  render: =>
    this.link.setMap(window.map)
    this.arrow.setMap(window.map) if this.arrow?

  #this method reads the path of points contained in the leg
  #and converts it into a polyline object to be drawn on the map
  #The Polyline map attribute will be null until render is called
  drawLink: (leg) ->
    sm_path = []
    for step in this.leg.steps
      for pt in step.path
        if !(pt in sm_path)
          sm_path.push pt

    this.link = new google.maps.Polyline({
      path: sm_path,
      map: null,
      strokeColor:  "blue",
      strokeOpacity: 0.6,
      strokeWeight: 6
    }); 

  #Arrow Positoning calculations involve the following functions:
  #displayArrow, getArrowStep, getArrowPositionIndex, and getAngleOfArrow
  #setUprrow calcuates the position and angle of the arrow to display along the route
  drawArrow: () ->
    #get the step along the route is about halfway
    arrow_step = this.getArrowStep(this.leg)
    #get the index of the latitude/longitude that is about halfway through the step
    lat_lng_index = this.getArrowPositionIndex(arrow_step)
    #get the arrows lat/lng from the path
    #It would be better to get the exact midpoint of the line using something like this:
    #google.maps.geometry.spherical.interpolate(legs[0].start_location, legs[0].end_location, .5)
    #The problem here is that this calculates the lat/lng midpoint of straight line between the points -- not along the route
    arrow_lat_lng_pos = arrow_step.path[lat_lng_index] 
    #angle the arrow towards this lat_lng - we only draw arrow if more than 2 steps
    arrow_angle_to = arrow_step.path[lat_lng_index + 1]
    
    #if the route has less than 2 steps than don't draw arrow
    this.arrow = null
    if arrow_step.path.length > 2
      #calculate direction of arrow
      dir = this.getAngleOfArrow(arrow_lat_lng_pos,arrow_angle_to)
      self = this
      this.arrow = new google.maps.Marker({
        position: arrow_lat_lng_pos,
        icon: new google.maps.MarkerImage('http://maps.google.com/mapfiles/dir_'+dir+'.png',
                    new google.maps.Size(24,24),
                    new google.maps.Point(0,0),
                    new google.maps.Point(12,12)
              ),
        map: null
      });

  #this moves through the steps array of the route to determine which step is about 
  #halfway through the leg
  getArrowStep: (leg) ->
    steps = leg.steps
    total_meters = 0
    for step,index in steps
      total_meters += step.distance.value
      arrow_step = step
      if(total_meters >= leg.distance.value / 2)
        break

    arrow_step
  
  #for the step parameter get the index of the middle
  #lat/lng
  getArrowPositionIndex: (step) ->
    Math.floor(step.path.length / 2)
  
  #this uses google spherical geometry functions to calculate the heading if our arrow.
  getAngleOfArrow: (pos, towards) ->
    dir = google.maps.geometry.spherical.computeHeading(pos, towards).toFixed(1);
    #round it to a multiple of 3 and correct unusable numbers
    dir = Math.round(dir/3) * 3;
    if (dir < 0)
      dir += 240
    if (dir > 117) 
      dir -= 120
    dir
  
  ################# The following handles the show and hide of link layers including the arrow heads
  hide_link: ->
    this.link.setMap(null)
    this.arrow.setMap(null) if this.arrow?
  
  show_link: ->
    this.link.setMap(window.map)
    this.arrow.setMap(window.map) if this.arrow?
