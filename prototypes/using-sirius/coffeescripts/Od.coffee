class window.sirius.Od extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Od()
    path_segments = xml.children('path_segments')
    obj.set('path_segments', $a.Path_segments.from_xml2(path_segments, deferred, object_with_id))
    decision_points = xml.children('decision_points')
    obj.set('decision_points', $a.Decision_points.from_xml2(decision_points, deferred, object_with_id))
    id = $(xml).attr('id')
    obj.set('id', id)
    network_id_origin = $(xml).attr('network_id_origin')
    obj.set('network_id_origin', network_id_origin)
    link_id_origin = $(xml).attr('link_id_origin')
    obj.set('link_id_origin', link_id_origin)
    network_id_destination = $(xml).attr('network_id_destination')
    obj.set('network_id_destination', network_id_destination)
    link_id_destination = $(xml).attr('link_id_destination')
    obj.set('link_id_destination', link_id_destination)
    if object_with_id.od
      object_with_id.od[obj.id] = obj
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('od')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('path_segments').to_xml(doc)) if @has('path_segments')
    xml.appendChild(@get('decision_points').to_xml(doc)) if @has('decision_points')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('network_id_origin', @get('network_id_origin')) if @has('network_id_origin')
    xml.setAttribute('link_id_origin', @get('link_id_origin')) if @has('link_id_origin')
    xml.setAttribute('network_id_destination', @get('network_id_destination')) if @has('network_id_destination')
    xml.setAttribute('link_id_destination', @get('link_id_destination')) if @has('link_id_destination')
    xml
  
  deep_copy: -> Od.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null