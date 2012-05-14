class window.aurora.MapNodeView extends window.aurora.MapMarkerView
	
	get_icon: ->
		if this.model.get("type") != "T" then this.get_marker('dot') else this.get_marker('square')
