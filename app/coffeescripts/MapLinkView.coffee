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
        self.directionsDisplay.setDirections(response)
        self.displayArrow()
    )

  displayArrow: ->
    dir=((Math.atan2(this.end.lng()-this.begin.lng(),this.end.lat()-this.begin.lat())*180)/Math.PI)+360
    ico=((dir-(dir%3))%120)
    self = this
    new google.maps.Marker({
      position: self.getArrowPosition(),
      icon: new google.maps.MarkerImage('http://maps.google.com/mapfiles/dir_'+ico+'.png',
                                 new google.maps.Size(24,24),
                                 new google.maps.Point(0,0),
                                 new google.maps.Point(12,12)
                                ),
      map: window.map
    });

  getArrowPosition: ->
    dx = this.end.lng()-this.begin.lng()
    dy = this.end.lat()-this.begin.lat()

    if (Math.abs(this.end.lng() - this.begin.lng()) > 180.0)
      dx = -dx

    sl = Math.sqrt((dx*dx)+(dy*dy))
    theta = Math.atan2(-dy,dx)

    #just put one arrow in the middle of the line
    x = this.begin.lng() + ((sl/2) * Math.cos(theta))
    y = this.begin.lat() - ((sl/2) * Math.sin(theta))

    new google.maps.LatLng(x,y)