class window.sirius.Display_position extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Display_position()
    point = xml.children('point')
    obj.set('point', _.map($(point), (point_i) -> $a.Point.from_xml2($(point_i), deferred, object_with_id)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('display_position')
    if @encode_references
      @encode_references()
    _.each(@get('point') || [], (a_point) -> xml.appendChild(a_point.to_xml(doc)))
    xml
  
  deep_copy: -> Display_position.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null