class window.aurora.NodeList extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.NodeList()
    node = xml.children('node')
    obj.set('node', _.map($(node), (node_i) -> $a.Node.from_xml2($(node_i), deferred, object_with_id)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('NodeList')
    if @encode_references
      @encode_references()
    _.each(@get('node') || [], (a_node) -> xml.appendChild(a_node.to_xml(doc)))
    xml
  
  deep_copy: -> NodeList.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null