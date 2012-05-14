class window.aurora.Components extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Components()
    swarm1 = $(xml).attr('swarm1')
    obj.set('swarm1', (swarm1.toString().toLowerCase() == 'true') if swarm1?)
    swarm2a = $(xml).attr('swarm2a')
    obj.set('swarm2a', (swarm2a.toString().toLowerCase() == 'true') if swarm2a?)
    swarm2b = $(xml).attr('swarm2b')
    obj.set('swarm2b', (swarm2b.toString().toLowerCase() == 'true') if swarm2b?)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('components')
    if @encode_references
      @encode_references()
    xml.setAttribute('swarm1', @get('swarm1')) if @has('swarm1')
    xml.setAttribute('swarm2a', @get('swarm2a')) if @has('swarm2a')
    xml.setAttribute('swarm2b', @get('swarm2b')) if @has('swarm2b')
    xml
  
  deep_copy: -> Components.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null