class window.sirius.RouteSegments extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.RouteSegments()
    route_segment = xml.children('route_segment')
    obj.set('route_segment', _.map($(route_segment), (route_segment_i) -> $a.Route_segment.from_xml2($(route_segment_i), deferred, object_with_id)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('RouteSegments')
    if @encode_references
      @encode_references()
    _.each(@get('route_segment') || [], (a_route_segment) -> xml.appendChild(a_route_segment.to_xml(doc)))
    xml
  
  deep_copy: -> RouteSegments.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null