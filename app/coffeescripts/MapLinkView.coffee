class window.aurora.MapLinkView extends Backbone.View

  initialize: (link, broker) -> 
    #Instantiate a directions service.
    renderOptions = {
      map: window.map,
      markerOptions: {visible: false},
      preserveViewport: true
    }
    this.directionsService = new google.maps.DirectionsService()
    this.directionsDisplay = new google.maps.DirectionsRenderer(renderOptions)
    this.begin =  window.aurora.Util.getLatLng link.get('begin').get('node')
    this.end = window.aurora.Util.getLatLng link.get('end').get('node')
    this.broker = broker
    this.broker.on('map:init', this.render, this)

  render: -> 
    #Create DirectionsRequest using DRIVING directions.
    request = {
      origin: this.begin,
      destination: this.end,
      travelMode: google.maps.TravelMode.DRIVING,
    }
    #Route the directions and pass the response to a
    #function to draw the full link for each step.
    self = this
    this.directionsService.route(request, (response, status) =>
      if (status == google.maps.DirectionsStatus.OK)
        warnings = $("#warnings_panel")
        warnings.innerHTML = "" + response.routes[0].warnings + ""
        self.displayArrow(response.routes[0].legs)
        self.directionsDisplay.setDirections(response)

    )

  displayArrow: (legs) ->
    dir=((Math.atan2(this.end.lat()-this.begin.lat(),this.end.lng()-this.begin.lng())*180)/Math.PI)+360
    ico=((dir-(dir%3))%120)
    self = this
    new google.maps.Marker({
      position: self.getArrowPosition(legs),
      icon: new google.maps.MarkerImage('http://maps.google.com/mapfiles/dir_'+ico+'.png',
                  new google.maps.Size(24,24),
                  new google.maps.Point(0,0),
                  new google.maps.Point(12,12)
            ),
      map: window.map
    });

  getArrowPosition: (legs) ->
    steps = legs[0].steps
    total_miles = 0
    for step, index in steps
      console.log step
      total_miles += step.lat_lng.distanceFrom(steps[index + 1].lat_lng)
      if(total_miles > 300) 
        break

    if (total_miles < 300)
      v0 = steps[0]
      v1 = steps[1]
    
    v0  
   
    
  