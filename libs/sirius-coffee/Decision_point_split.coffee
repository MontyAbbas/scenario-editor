class window.sirius.Decision_point_split extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Decision_point_split()
    route_segment_in = $(xml).attr('route_segment_in')
    obj.set('route_segment_in', route_segment_in)
    route_segment_out = $(xml).attr('route_segment_out')
    obj.set('route_segment_out', route_segment_out)
    obj.set('text', xml.text())
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('decision_point_split')
    if @encode_references
      @encode_references()
    xml.setAttribute('route_segment_in', @get('route_segment_in')) if @has('route_segment_in')
    xml.setAttribute('route_segment_out', @get('route_segment_out')) if @has('route_segment_out')
    xml.appendChild(doc.createTextNode($a.ArrayText.emit(@get('text') || [])))
    xml
  
  deep_copy: -> Decision_point_split.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null