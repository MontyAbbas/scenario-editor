window.main_stuff.init = ->
  window.sirius.MapView.initializeMap()
    
window.main_stuff.display = ->  
  node_markers = {}
  broker = _.clone( Backbone.Events)
  network = window.textarea_scenario.get('networklist').get('network')[0]
  mapView = new window.sirius.MapView network, broker
  broker.trigger('map:init')

