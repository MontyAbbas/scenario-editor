class window.sirius.Settings extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Settings()
    VehicleTypes = xml.children('VehicleTypes')
    obj.set('vehicletypes', $a.VehicleTypes.from_xml2(VehicleTypes, deferred, object_with_id))
    units = xml.children('units')
    obj.set('units', $a.Units.from_xml2(units, deferred, object_with_id))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('settings')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('vehicletypes').to_xml(doc)) if @has('vehicletypes')
    xml.appendChild(@get('units').to_xml(doc)) if @has('units')
    xml
  
  deep_copy: -> Settings.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null