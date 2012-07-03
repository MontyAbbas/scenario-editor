# MapMarkerView is base class for scenario elements represented by a 
# single latitude and longitude on the Map
class window.sirius.MapMarkerView extends Backbone.View
  $a = window.sirius
  
  initialize: (@model, @latLng) ->
    @draw()
    $a.broker.on('map:init', @render, @)

  render: =>
    @marker.setMap($a.map)
    @

  # Draw the marker by determining the type of icon
  # is used for each type of element. The default is the 
  # our standard dot.png. Each subclasses overrides get_icon
  # to pass the correct icon 
  draw: ->
    @marker = new google.maps.Marker({
        map: null
        position: @latLng 
        draggable: true
        icon: @get_icon 'dot'
        title: "Name: " + @model.get('name') + "\nLatitude: " + @latLng.lat() + "\nLongitude: " + @latLng.lng()
      });
    google.maps.event.addListener(@marker, "dragend", @dragMarker());
    google.maps.event.addListener($a.map, "dragend", @dragMap());
    
  get_icon: (img) ->
    new google.maps.MarkerImage('../libs/data/img/' + img + '.png',
      new google.maps.Size(32, 32),
      new google.maps.Point(0,0),
      new google.maps.Point(16, 16)
    );

  # events used to move the marker and update its position
  # as well as to move map as the marker moves
  dragMarker: =>
    @latLng = @marker.getPosition();
    $a.map.panTo(@latLng);

  dragMap: =>
    @latLng = $a.map.getCenter();
    @marker.setPosition(@latLng);
  
  ################# The following handles the show and hide of node layers
  hide_marker: =>
    @marker.setMap(null)

  show_marker: =>
    @marker.setMap($a.map)
  