class window.sirius.Weavingfactors extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Weavingfactors()
    network_id = $(xml).attr('network_id')
    obj.set('network_id', network_id)
    node_id = $(xml).attr('node_id')
    obj.set('node_id', node_id)
    obj.set('text', xml.text())
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('weavingfactors')
    if @encode_references
      @encode_references()
    xml.setAttribute('network_id', @get('network_id')) if @has('network_id')
    xml.setAttribute('node_id', @get('node_id')) if @has('node_id')
    xml.appendChild(doc.createTextNode($a.ArrayText.emit(@get('text') || [])))
    xml
  
  deep_copy: -> Weavingfactors.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null