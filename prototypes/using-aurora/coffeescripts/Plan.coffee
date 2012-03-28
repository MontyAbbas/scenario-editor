class window.aurora.Plan extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Plan()
    intersection = xml.find('intersection')
    obj.set 'intersection', _.map(intersection, (intersection_i) -> $a.Intersection.from_xml2(intersection_i, deferred, object_with_id))
    id = $(xml).attr('id')
    obj.set 'id', xml.id
    cyclelength = $(xml).attr('cyclelength')
    obj.set 'cyclelength', Number(cyclelength)
    if object_with_id.plan
      object_with_id.plan[obj.id] = obj
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('plan')
    if @encode_references
      @encode_references()
    _.each(@get('intersection') || [], (a_intersection) -> xml.appendChild(a_intersection.to_xml()))
    xml.setAttribute('id', @get('id'))
    xml.setAttribute('cyclelength', @get('cyclelength'))
    xml
  
  deep_copy: -> Plan.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null