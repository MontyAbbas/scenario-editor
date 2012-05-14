class window.sirius.VehicleTypes extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.VehicleTypes()
    vehicleType = xml.children('vehicleType')
    obj.set('vehicletype', _.map($(vehicleType), (vehicleType_i) -> $a.VehicleType.from_xml2($(vehicleType_i), deferred, object_with_id)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('VehicleTypes')
    if @encode_references
      @encode_references()
    _.each(@get('vehicletype') || [], (a_vehicletype) -> xml.appendChild(a_vehicletype.to_xml(doc)))
    xml
  
  deep_copy: -> VehicleTypes.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null