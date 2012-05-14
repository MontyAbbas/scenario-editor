class window.sirius.VehicleType extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.VehicleType()
    name = $(xml).attr('name')
    obj.set('name', name)
    weight = $(xml).attr('weight')
    obj.set('weight', Number(weight))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('vehicleType')
    if @encode_references
      @encode_references()
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('weight', @get('weight')) if @has('weight')
    xml
  
  deep_copy: -> VehicleType.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null