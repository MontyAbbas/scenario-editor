class window.aurora.MapLinkView extends Backbone.View

  initialize: (link, broker) -> 
    #Instantiate a directions service.
    renderOptions = {
      map: window.map,
      markerOptions: {visible: false}
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
      travelMode: google.maps.TravelMode.DRIVING
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
    new google.maps.Marker({
      position: this.begin,
      icon: new google.maps.MarkerImage('http://maps.google.com/mapfiles/dir_'+ico+'.png',
                                 new google.maps.Size(24,24),
                                 new google.maps.Point(0,0),
                                 new google.maps.Point(12,12)
                                ),
      map: window.map
    });

