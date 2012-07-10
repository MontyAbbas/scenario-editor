class window.sirius.MapNetworkModel extends Backbone.Model
  $a = window.sirius
  @LINKS : []
  @NODES : []
  
  initialize: () ->
    MapNetworkModel.LINKS = $a.models.get('networklist').get('network')[0].get('linklist').get('link')
    MapNetworkModel.NODES = $a.models.get('networklist').get('network')[0].get('nodelist').get('node')