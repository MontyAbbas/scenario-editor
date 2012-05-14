class window.sirius.Signal extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Signal()
    phase = xml.children('phase')
    obj.set('phase', _.map($(phase), (phase_i) -> $a.Phase.from_xml2($(phase_i), deferred, object_with_id)))
    id = $(xml).attr('id')
    obj.set('id', id)
    node_id = $(xml).attr('node_id')
    obj.set('node_id', node_id)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('signal')
    if @encode_references
      @encode_references()
    _.each(@get('phase') || [], (a_phase) -> xml.appendChild(a_phase.to_xml(doc)))
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('node_id', @get('node_id')) if @has('node_id')
    xml
  
  deep_copy: -> Signal.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null