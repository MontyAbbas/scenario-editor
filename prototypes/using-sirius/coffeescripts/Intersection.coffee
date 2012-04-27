class window.sirius.Intersection extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Intersection()
    stage = xml.children('stage')
    obj.set('stage', _.map($(stage), (stage_i) -> $a.Stage.from_xml2($(stage_i), deferred, object_with_id)))
    network_id = $(xml).attr('network_id')
    obj.set('network_id', network_id)
    node_id = $(xml).attr('node_id')
    obj.set('node_id', node_id)
    offset = $(xml).attr('offset')
    obj.set('offset', Number(offset))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('intersection')
    if @encode_references
      @encode_references()
    _.each(@get('stage') || [], (a_stage) -> xml.appendChild(a_stage.to_xml(doc)))
    xml.setAttribute('network_id', @get('network_id')) if @has('network_id')
    xml.setAttribute('node_id', @get('node_id')) if @has('node_id')
    xml.setAttribute('offset', @get('offset')) if @has('offset')
    xml
  
  deep_copy: -> Intersection.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null