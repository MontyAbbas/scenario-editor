class window.aurora.MapMarkerView extends Backbone.View
	
	initialize: (model,broker,lat,lng) -> 
		_.bindAll(this, 'render','dragMarker', 'dragMap')
		this.model = model
		this.broker = broker
		this.broker.on('map:init', this.render, this)
		this.latitude =  lat
		this.longitude = lng

	render: ->
		self = this
		this.latlng = new google.maps.LatLng(this.latitude, this.longitude);
		this.marker = new google.maps.Marker({
					map: $a.map,
					position: this.latlng, 
					draggable: true,
					icon: self.get_icon('dot')
				});
		google.maps.event.addListener(this.marker, "dragend", this.dragMarker());
		google.maps.event.addListener($a.map, "dragend", this.dragMap());
		this

	get_icon: (img) ->
		get_marker(img)
		
	get_marker: (img) ->
			new google.maps.MarkerImage('data/img/' + img + '.png',
					new google.maps.Size(32, 32),
					new google.maps.Point(0,0),
					new google.maps.Point(16, 16));

	dragMarker: ->
		self.latlng = this.marker.getPosition();
		$a.map.panTo(self.latlng);
		
	dragMap: ->
		self.latlng = $a.map.getCenter();
		this.marker.setPosition(self.latlng);