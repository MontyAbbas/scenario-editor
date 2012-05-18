class window.aurora.MapLinkView extends Backbone.View

  initialize: (link, broker) -> 
    #Instantiate a directions service.
    this.directionsService = new google.maps.DirectionsService()
    renderOptions = {
      map: window.map,
      markerOptions: {visible: false}
    }
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
    )


            
 