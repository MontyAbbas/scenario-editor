class window.sirius.MapMarkerView extends Backbone.View

  initialize: (model,broker,lat_lng) ->
    this.model = model
    this.latlng = lat_lng
    this.draw()
    this.broker = broker
    this.broker.on('map:init', this.render, this)

  render: =>
    this.marker.setMap(window.map)
    
  draw: ->
    this.marker = new google.maps.Marker({
        map: null,
        position: this.latlng, 
        draggable: true,
        icon: this.get_icon 'dot'
        title: "Latitude: " + this.latlng.lat() + "\nLongitude: " + this.latlng.lng()
      });
    google.maps.event.addListener(this.marker, "dragend", this.dragMarker());
    google.maps.event.addListener(window.map, "dragend", this.dragMap());
    
  get_icon: (img) ->
    new google.maps.MarkerImage('../libs/data/img/' + img + '.png',
      new google.maps.Size(32, 32),
      new google.maps.Point(0,0),
      new google.maps.Point(16, 16)
    );

  dragMarker: =>
    self.latlng = this.marker.getPosition();
    window.map.panTo(self.latlng);

  dragMap: =>
    self.latlng = window.map.getCenter();
    this.marker.setPosition(self.latlng);
  
  ################# The following handles the show and hide of node layers including the arrow heads
  hide_marker: ->
    this.marker.setMap(null)

  show_marker: ->
    this.marker.setMap(window.map)
  