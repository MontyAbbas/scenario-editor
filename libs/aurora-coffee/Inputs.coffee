class window.aurora.Inputs extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Inputs()
    input = xml.children('input')
    obj.set('input', _.map($(input), (input_i) -> $a.Input.from_xml2($(input_i), deferred, object_with_id)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('inputs')
    if @encode_references
      @encode_references()
    _.each(@get('input') || [], (a_input) -> xml.appendChild(a_input.to_xml(doc)))
    xml
  
  deep_copy: -> Inputs.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null