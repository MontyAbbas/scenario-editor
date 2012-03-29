class window.aurora.To extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.To()
    ALatLng = xml.find('ALatLng')
    obj.set('alatlng', $a.ALatLng.from_xml2(ALatLng, deferred, object_with_id))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('To')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('alatlng').to_xml()) if @has('alatlng')
    xml
  
  deep_copy: -> To.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null