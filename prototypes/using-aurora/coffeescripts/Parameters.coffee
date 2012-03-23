class window.aurora.Parameters extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Parameters()
    parameter = xml.find('parameter')
    obj.set 'parameter', _.map(parameter, (parameter_i) -> $a.Parameter.from_xml2(parameter_i, deferred, object_with_id))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('parameters')
    if @encode_references
      @encode_references()
    _.each(@get('parameter') || [], (a_parameter) -> xml.appendChild(a_parameter.to_xml()))
    xml
  
  deep_copy: -> Parameters.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null