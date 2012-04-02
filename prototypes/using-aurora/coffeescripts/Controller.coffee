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
    components = xml.find('components')
    obj.set('components', $a.Components.from_xml2(components, deferred, object_with_id))
    zones = xml.find('zones')
    obj.set('zones', $a.Zones.from_xml2(zones, deferred, object_with_id))
    onramps = xml.find('onramps')
    obj.set('onramps', $a.Onramps.from_xml2(onramps, deferred, object_with_id))
    parameters = xml.find('parameters')
    obj.set('parameters', _.reduce(parameters.find("parameter"),
          (acc,par_xml) ->
            wrapped_xml = $(par_xml);
            acc[wrapped_xml.attr('name')] = wrapped_xml.attr('value')
            acc
          {}
    ))
    limits = xml.find('limits')
    obj.set('limits', $a.Limits.from_xml2(limits, deferred, object_with_id))
    qcontroller = xml.find('qcontroller')
    obj.set('qcontroller', $a.Qcontroller.from_xml2(qcontroller, deferred, object_with_id))
    table = xml.find('table')
    obj.set('table', $a.Table.from_xml2(table, deferred, object_with_id))
    display_position = xml.find('display_position')
    obj.set('display_position', $a.Display_position.from_xml2(display_position, deferred, object_with_id))
    PlanSequence = xml.find('PlanSequence')
    obj.set('plansequence', $a.PlanSequence.from_xml2(PlanSequence, deferred, object_with_id))
    PlanList = xml.find('PlanList')
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
    xml.appendChild(@get('components').to_xml()) if @has('components')
    xml.appendChild(@get('zones').to_xml()) if @has('zones')
    xml.appendChild(@get('onramps').to_xml()) if @has('onramps')
    if @has('parameters')
      parameters_xml = doc.createElement('parameters')
      _.each(@get('parameters'), (par_name) ->
          parameter_xml = doc.createElement('parameter')
          parameter_xml.setAttribute(par_name, parameters[par_name])
          parameters_xml.appendChild(parameter_xml)
      )
      xml.appendChild(parameters_xml)
    
    xml.appendChild(@get('limits').to_xml()) if @has('limits')
    xml.appendChild(@get('qcontroller').to_xml()) if @has('qcontroller')
    xml.appendChild(@get('table').to_xml()) if @has('table')
    xml.appendChild(@get('display_position').to_xml()) if @has('display_position')
    xml.appendChild(@get('plansequence').to_xml()) if @has('plansequence')
    xml.appendChild(@get('planlist').to_xml()) if @has('planlist')
    xml.setAttribute('name', @get('name'))
    xml.setAttribute('type', @get('type'))
    xml.setAttribute('dt', @get('dt'))
    if @has('usesensors') && @usesensors != false then xml.setAttribute('usesensors', @get('usesensors'))
    if @has('node_id') && @node_id != "" then xml.setAttribute('node_id', @get('node_id'))
    if @has('link_id') && @link_id != "" then xml.setAttribute('link_id', @get('link_id'))
    if @has('network_id') && @network_id != "" then xml.setAttribute('network_id', @get('network_id'))
    xml
  
  deep_copy: -> Controller.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null