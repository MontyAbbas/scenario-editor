class window.aurora.Components extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Components()
    swarm1 = xml.find('swarm1')
    obj.set 'swarm1', (swarm1.toString().toLowerCase() == 'true')
    swarm2a = xml.find('swarm2a')
    obj.set 'swarm2a', (swarm2a.toString().toLowerCase() == 'true')
    swarm2b = xml.find('swarm2b')
    obj.set 'swarm2b', (swarm2b.toString().toLowerCase() == 'true')
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('components')
    if @encode_references
      @encode_references()
    xml.setAttribute('swarm1', @get('swarm1'))
    xml.setAttribute('swarm2a', @get('swarm2a'))
    xml.setAttribute('swarm2b', @get('swarm2b'))
    xml
  
  deep_copy: -> Components.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null