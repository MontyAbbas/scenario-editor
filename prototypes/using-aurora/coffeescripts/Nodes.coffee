class window.aurora.Nodes extends Backbone.Model
  @dim = 1
  @delims = [","]
  @cell_type = "node"
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Nodes()
    deferred.push(=> obj.set('cells', $a.ArrayText.parse(xml.text(), @delims, "node", object_with_id.node)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('nodes')
    if @encode_references
      @encode_references()
    xml.appendChild(doc.createTextNode($a.ArrayText.emit((@get('cells') || []).map((x) -> x.id), @delims)))
    xml
  
  deep_copy: -> Nodes.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null