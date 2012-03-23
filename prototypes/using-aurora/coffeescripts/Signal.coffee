class window.aurora.Signal extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Signal()
    phase = xml.find('phase')
    obj.set 'phase', _.map(phase, (phase_i) -> $a.Phase.from_xml2(phase_i, deferred, object_with_id))
    node_id = xml.find('node_id')
    obj.set 'node_id', xml.node_id
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('signal')
    if @encode_references
      @encode_references()
    _.each(@get('phase') || [], (a_phase) -> xml.appendChild(a_phase.to_xml()))
    xml.setAttribute('node_id', @get('node_id'))
    xml
  
  deep_copy: -> Signal.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null