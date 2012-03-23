class window.aurora.Plan_reference extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Plan_reference()
    plan_id = xml.find('plan_id')
    obj.set 'plan_id', xml.plan_id
    start_time = xml.find('start_time')
    obj.set 'start_time', Number(start_time)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('plan_reference')
    if @encode_references
      @encode_references()
    xml.setAttribute('plan_id', @get('plan_id'))
    xml.setAttribute('start_time', @get('start_time'))
    xml
  
  deep_copy: -> Plan_reference.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null