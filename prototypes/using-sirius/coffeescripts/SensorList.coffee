class window.sirius.SensorList extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.SensorList()
    sensor = xml.children('sensor')
    obj.set('sensor', _.map($(sensor), (sensor_i) -> $a.Sensor.from_xml2($(sensor_i), deferred, object_with_id)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('SensorList')
    if @encode_references
      @encode_references()
    _.each(@get('sensor') || [], (a_sensor) -> xml.appendChild(a_sensor.to_xml(doc)))
    xml
  
  deep_copy: -> SensorList.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null