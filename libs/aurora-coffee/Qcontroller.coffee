class window.aurora.Qcontroller extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Qcontroller()
    parameters = xml.children('parameters')
    obj.set('parameters', _.reduce(parameters.find("parameter"),
          (acc,par_xml) ->
            wrapped_xml = $(par_xml);
            acc[wrapped_xml.attr('name')] = wrapped_xml.attr('value')
            acc
          {}
    ))
    type = $(xml).attr('type')
    obj.set('type', type)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('qcontroller')
    if @encode_references
      @encode_references()
    if @has('parameters')
      parameters_xml = doc.createElement('parameters')
      _.each(@get('parameters'), (par_val, par_name) ->
          parameter_xml = doc.createElement('parameter')
          parameter_xml.setAttribute(par_name, par_val)
          parameters_xml.appendChild(parameter_xml)
      )
      xml.appendChild(parameters_xml)
    
    xml.setAttribute('type', @get('type')) if @has('type')
    xml
  
  deep_copy: -> Qcontroller.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null