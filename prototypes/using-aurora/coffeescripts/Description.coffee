class window.aurora.Description extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Description()
    
    obj.set 'text', xml.text()
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('description')
    if @encode_references
      @encode_references()
    xml.appendChild(doc.createTextNode($a.ArrayText.emit(@get('text') || [])))
    xml
  
  deep_copy: -> Description.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null