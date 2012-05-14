class window.sirius.PathSegements extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.PathSegements()
    path_segment = xml.children('path_segment')
    obj.set('path_segment', _.map($(path_segment), (path_segment_i) -> $a.Path_segment.from_xml2($(path_segment_i), deferred, object_with_id)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('PathSegements')
    if @encode_references
      @encode_references()
    _.each(@get('path_segment') || [], (a_path_segment) -> xml.appendChild(a_path_segment.to_xml(doc)))
    xml
  
  deep_copy: -> PathSegements.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null