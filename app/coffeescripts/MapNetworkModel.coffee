class window.sirius.MapNetworkModel extends Backbone.Model
  $a = window.sirius
  @LINKS : []
  @NODES : []
  
  initialize: ->
    MapNetworkModel.LINKS = $a.models.get('networklist').get('network')[0].get('linklist').get('link')
    
    MapNetworkModel.NODES = $a.models.get('networklist').get('network')[0].get('nodelist').get('node')
    
    $a.broker.on('map:clearMap', @removeAll, @)

  #Removes all links and nodes on the map
  removeAll: ->
    @LINKS = []
    @NODES = []
