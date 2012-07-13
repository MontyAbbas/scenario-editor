class window.sirius.NetworkList extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.NetworkList()
    network = xml.children('network')
    obj.set('network', _.map($(network), (network_i) -> $a.Network.from_xml2($(network_i), deferred, object_with_id)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('NetworkList')
    if @encode_references
      @encode_references()
    _.each(@get('network') || [], (a_network) -> xml.appendChild(a_network.to_xml(doc)))
    xml
  
  deep_copy: -> NetworkList.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null