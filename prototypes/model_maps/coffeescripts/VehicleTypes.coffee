class window.aurora.VehicleTypes extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.VehicleTypes()
    vtype = xml.children('vtype')
    obj.set('vtype', _.map($(vtype), (vtype_i) -> $a.Vtype.from_xml2($(vtype_i), deferred, object_with_id)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('VehicleTypes')
    if @encode_references
      @encode_references()
    _.each(@get('vtype') || [], (a_vtype) -> xml.appendChild(a_vtype.to_xml(doc)))
    xml
  
  deep_copy: -> VehicleTypes.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null