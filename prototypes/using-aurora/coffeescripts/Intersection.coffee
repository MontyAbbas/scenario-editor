class window.aurora.Intersection extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Intersection()
    stage = xml.find('stage')
    obj.set('stage', _.map($(stage), (stage_i) -> $a.Stage.from_xml2($(stage_i), deferred, object_with_id)))
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
    _.each(@get('stage') || [], (a_stage) -> xml.appendChild(a_stage.to_xml()))
    xml.setAttribute('node_id', @get('node_id'))
    xml.setAttribute('offset', @get('offset'))
    xml
  
  deep_copy: -> Intersection.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null