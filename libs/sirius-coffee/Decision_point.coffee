class window.sirius.Decision_point extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Decision_point()
    VehicleTypeOrder = xml.children('VehicleTypeOrder')
    obj.set('vehicletypeorder', $a.VehicleTypeOrder.from_xml2(VehicleTypeOrder, deferred, object_with_id))
    decision_point_split = xml.children('decision_point_split')
    obj.set('decision_point_split', _.map($(decision_point_split), (decision_point_split_i) -> $a.Decision_point_split.from_xml2($(decision_point_split_i), deferred, object_with_id)))
    id = $(xml).attr('id')
    obj.set('id', id)
    node_id = $(xml).attr('node_id')
    obj.set('node_id', node_id)
    start_time = $(xml).attr('start_time')
    obj.set('start_time', Number(start_time))
    dt = $(xml).attr('dt')
    obj.set('dt', Number(dt))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('decision_point')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('vehicletypeorder').to_xml(doc)) if @has('vehicletypeorder')
    _.each(@get('decision_point_split') || [], (a_decision_point_split) -> xml.appendChild(a_decision_point_split.to_xml(doc)))
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('node_id', @get('node_id')) if @has('node_id')
    if @has('start_time') && @start_time != 0 then xml.setAttribute('start_time', @get('start_time'))
    xml.setAttribute('dt', @get('dt')) if @has('dt')
    xml
  
  deep_copy: -> Decision_point.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null