class window.aurora.Qcontroller extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Qcontroller()
    parameters = xml.find('parameters')
    obj.set 'parameters', _.reduce(parameters.find("parameter"),
          (acc,par_xml) ->
            acc[par_xml.attr('name')] = par_xml.attr('value')
            acc
          {}
    )
    type = xml.find('type')
    obj.set 'type', xml.type
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('qcontroller')
    if @encode_references
      @encode_references()
    if @has('parameters')
      parameters_xml = doc.createElement('parameters')
      _.each(@get('parameters'), (par_name) ->
          parameter_xml = doc.createElement('parameter')
          parameter_xml.setAttribute(par_name, parameters[par_name])
          parameters_xml.appendChild(parameter_xml)
      )
      xml.appendChild(parameters_xml)
    
    xml.setAttribute('type', @get('type'))
    xml
  
  deep_copy: -> Qcontroller.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null