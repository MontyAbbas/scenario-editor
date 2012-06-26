class window.sirius.MapMarkerView extends Backbone.View

  initialize: (model,broker,lat_lng) ->
    @model = model
    @latlng = lat_lng
    @draw()
    @broker = broker
    @broker.on('map:init', @render, @)

  render: =>
    @marker.setMap(window.map)
    
  draw: ->
    @marker = new google.maps.Marker({
        map: null,
        position: @latlng, 
        draggable: true,
        icon: @get_icon 'dot'
        title: "Latitude: " + @latlng.lat() + "\nLongitude: " + @latlng.lng()
      });
    google.maps.event.addListener(@marker, "dragend", @dragMarker());
    google.maps.event.addListener(window.map, "dragend", @dragMap());
    
  get_icon: (img) ->
    new google.maps.MarkerImage('../libs/data/img/' + img + '.png',
      new google.maps.Size(32, 32),
      new google.maps.Point(0,0),
      new google.maps.Point(16, 16)
    );

  dragMarker: =>
    self.latlng = @marker.getPosition();
    window.map.panTo(self.latlng);

  dragMap: =>
    self.latlng = window.map.getCenter();
    @marker.setPosition(self.latlng);
  
  ################# The following handles the show and hide of node layers including the arrow heads
  hide_marker: ->
    @marker.setMap(null)

  show_marker: ->
    @marker.setMap(window.map)
  