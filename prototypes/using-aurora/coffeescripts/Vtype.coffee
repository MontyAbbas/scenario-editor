class window.aurora.Vtype extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Vtype()
    name = xml.find('name')
    obj.set 'name', xml.name
    weight = xml.find('weight')
    obj.set 'weight', Number(weight)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('vtype')
    if @encode_references
      @encode_references()
    xml.setAttribute('name', @get('name'))
    xml.setAttribute('weight', @get('weight'))
    xml
  
  deep_copy: -> Vtype.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null