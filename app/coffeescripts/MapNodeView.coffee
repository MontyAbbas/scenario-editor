class window.aurora.MapNodeView extends window.aurora.MapMarkerView
  
  get_icon: ->
    if this.model.get("type") != "T" then super 'dot' else super 'square'
