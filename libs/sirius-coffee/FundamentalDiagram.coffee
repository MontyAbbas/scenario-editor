class window.sirius.FundamentalDiagram extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.FundamentalDiagram()
    free_flow_speed = $(xml).attr('free_flow_speed')
    obj.set('free_flow_speed', Number(free_flow_speed))
    congestion_speed = $(xml).attr('congestion_speed')
    obj.set('congestion_speed', Number(congestion_speed))
    capacity = $(xml).attr('capacity')
    obj.set('capacity', Number(capacity))
    jam_density = $(xml).attr('jam_density')
    obj.set('jam_density', Number(jam_density))
    capacity_drop = $(xml).attr('capacity_drop')
    obj.set('capacity_drop', Number(capacity_drop))
    std_dev_capacity = $(xml).attr('std_dev_capacity')
    obj.set('std_dev_capacity', Number(std_dev_capacity))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('fundamentalDiagram')
    if @encode_references
      @encode_references()
    xml.setAttribute('free_flow_speed', @get('free_flow_speed')) if @has('free_flow_speed')
    xml.setAttribute('congestion_speed', @get('congestion_speed')) if @has('congestion_speed')
    xml.setAttribute('capacity', @get('capacity')) if @has('capacity')
    xml.setAttribute('jam_density', @get('jam_density')) if @has('jam_density')
    if @has('capacity_drop') && @capacity_drop != 0.0 then xml.setAttribute('capacity_drop', @get('capacity_drop'))
    xml.setAttribute('std_dev_capacity', @get('std_dev_capacity')) if @has('std_dev_capacity')
    xml
  
  deep_copy: -> FundamentalDiagram.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null