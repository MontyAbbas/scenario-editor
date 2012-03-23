class window.aurora.Settings extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Settings()
    display = xml.find('display')
    obj.set 'display', $a.Display.from_xml2(display, deferred, object_with_id)
    VehicleTypes = xml.find('VehicleTypes')
    obj.set 'vehicletypes', $a.VehicleTypes.from_xml2(VehicleTypes, deferred, object_with_id)
    units = xml.find('units')
    obj.set 'units', $a.Units.from_xml2(units, deferred, object_with_id)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('settings')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('display').to_xml()) if @has('display')
    xml.appendChild(@get('vehicletypes').to_xml()) if @has('vehicletypes')
    xml.appendChild(@get('units').to_xml()) if @has('units')
    xml
  
  deep_copy: -> Settings.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null