class window.aurora.MapMarkerView extends Backbone.View
	
	initialize: (model,broker,lat_lng) -> 
		_.bindAll(this, 'render','dragMarker', 'dragMap')
		this.model = model
		this.broker = broker
		this.broker.on('map:init', this.render, this)
		this.latitude =  lat_lng.lat()
		this.longitude = lat_lng.lng()

	render: ->
		self = this
		this.latlng = new google.maps.LatLng(this.latitude, this.longitude);
		this.marker = new google.maps.Marker({
					map: window.map,
					position: this.latlng, 
					draggable: true,
					icon: self.get_icon('dot')
					title: "Latitude: " + this.latlng.lat() + "\nLongitude: " + this.latlng.lng()
				});
		google.maps.event.addListener(this.marker, "dragend", this.dragMarker());
		google.maps.event.addListener(window.map, "dragend", this.dragMap());
		this

	get_icon: (img) ->
		new google.maps.MarkerImage('../libs/data/img/' + img + '.png',
				new google.maps.Size(32, 32),
				new google.maps.Point(0,0),
				new google.maps.Point(16, 16));

	dragMarker: ->
		self.latlng = this.marker.getPosition();
		window.map.panTo(self.latlng);
		
	dragMap: ->
		self.latlng = window.map.getCenter();
		this.marker.setPosition(self.latlng);