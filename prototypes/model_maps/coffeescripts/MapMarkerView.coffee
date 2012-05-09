class window.aurora.MapMarkerView extends Backbone.View
	
	initialize: (model,broker,lat,lng) -> 
		_.bindAll(this, 'render','dragMarker', 'dragMap')
		this.model = model
		this.broker = broker
		this.broker.on('map:init', this.render, this)
		this.latitude =  lat
		this.longitude = lng

	render: ->
		this.latlng = new google.maps.LatLng(this.latitude, this.longitude);
		this.marker = new google.maps.Marker({
					map: window.map,
					position: this.latlng, 
					draggable: true,
					icon: this.get_icon
				});
		self = this
		google.maps.event.addListener(this.marker, "dragend", this.dragMarker());
		google.maps.event.addListener(window.map, "dragend", this.dragMap());
		this

	get_icon: ->
		Util.get_image("dot")

	dragMarker: ->
		self.latlng = this.marker.getPosition();
		window.map.panTo(self.latlng);
		
	dragMap: ->
		self.latlng = window.map.getCenter();
		this.marker.setPosition(self.latlng);