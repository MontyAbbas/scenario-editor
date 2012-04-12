class window.aurora.Controller extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Controller()
    components = xml.children('components')
    obj.set('components', $a.Components.from_xml2(components, deferred, object_with_id))
    zones = xml.children('zones')
    obj.set('zones', $a.Zones.from_xml2(zones, deferred, object_with_id))
    onramps = xml.children('onramps')
    obj.set('onramps', $a.Onramps.from_xml2(onramps, deferred, object_with_id))
    parameters = xml.children('parameters')
    obj.set('parameters', _.reduce(parameters.find("parameter"),
          (acc,par_xml) ->
            wrapped_xml = $(par_xml);
            acc[wrapped_xml.attr('name')] = wrapped_xml.attr('value')
            acc
          {}
    ))
    limits = xml.children('limits')
    obj.set('limits', $a.Limits.from_xml2(limits, deferred, object_with_id))
    qcontroller = xml.children('qcontroller')
    obj.set('qcontroller', $a.Qcontroller.from_xml2(qcontroller, deferred, object_with_id))
    table = xml.children('table')
    obj.set('table', $a.Table.from_xml2(table, deferred, object_with_id))
    display_position = xml.children('display_position')
    obj.set('display_position', $a.Display_position.from_xml2(display_position, deferred, object_with_id))
    PlanSequence = xml.children('PlanSequence')
    obj.set('plansequence', $a.PlanSequence.from_xml2(PlanSequence, deferred, object_with_id))
    PlanList = xml.children('PlanList')
    obj.set('planlist', $a.PlanList.from_xml2(PlanList, deferred, object_with_id))
    name = $(xml).attr('name')
    obj.set('name', name)
    type = $(xml).attr('type')
    obj.set('type', type)
    dt = $(xml).attr('dt')
    obj.set('dt', Number(dt))
    usesensors = $(xml).attr('usesensors')
    obj.set('usesensors', (usesensors.toString().toLowerCase() == 'true') if usesensors?)
    node_id = $(xml).attr('node_id')
    obj.set('node_id', node_id)
    link_id = $(xml).attr('link_id')
    obj.set('link_id', link_id)
    network_id = $(xml).attr('network_id')
    obj.set('network_id', network_id)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('controller')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('components').to_xml(doc)) if @has('components')
    xml.appendChild(@get('zones').to_xml(doc)) if @has('zones')
    xml.appendChild(@get('onramps').to_xml(doc)) if @has('onramps')
    if @has('parameters')
      parameters_xml = doc.createElement('parameters')
      _.each(@get('parameters'), (par_val, par_name) ->
          parameter_xml = doc.createElement('parameter')
          parameter_xml.setAttribute(par_name, par_val)
          parameters_xml.appendChild(parameter_xml)
      )
      xml.appendChild(parameters_xml)
    
    xml.appendChild(@get('limits').to_xml(doc)) if @has('limits')
    xml.appendChild(@get('qcontroller').to_xml(doc)) if @has('qcontroller')
    xml.appendChild(@get('table').to_xml(doc)) if @has('table')
    xml.appendChild(@get('display_position').to_xml(doc)) if @has('display_position')
    xml.appendChild(@get('plansequence').to_xml(doc)) if @has('plansequence')
    xml.appendChild(@get('planlist').to_xml(doc)) if @has('planlist')
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('type', @get('type')) if @has('type')
    xml.setAttribute('dt', @get('dt')) if @has('dt')
    if @has('usesensors') && @usesensors != false then xml.setAttribute('usesensors', @get('usesensors'))
    if @has('node_id') && @node_id != "" then xml.setAttribute('node_id', @get('node_id'))
    if @has('link_id') && @link_id != "" then xml.setAttribute('link_id', @get('link_id'))
    if @has('network_id') && @network_id != "" then xml.setAttribute('network_id', @get('network_id'))
    xml
  
  deep_copy: -> Controller.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null