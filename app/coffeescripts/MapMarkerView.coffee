class window.sirius.MapMarkerView extends Backbone.View
  $a = window.sirius
  
  initialize: (@model, @latLng) ->
    @draw()
    $a.AppView.broker.on('map:init', @render(), @)

  render: =>
    @marker.setMap(window.map)
    @
    
  draw: ->
    @marker = new google.maps.Marker({
        map: null,
        position: @latLng, 
        draggable: true,
        icon: @get_icon 'dot'
        title: "Latitude: " + @latLng.lat() + "\nLongitude: " + @latLng.lng()
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
    @latLng = @marker.getPosition();
    window.map.panTo(@latLng);

  dragMap: =>
    @latLng = window.map.getCenter();
    @marker.setPosition(@latLng);
  
  ################# The following handles the show and hide of node layers including the arrow heads
  hide_marker: ->
    @marker.setMap(null)

  show_marker: ->
    @marker.setMap(window.map)
  