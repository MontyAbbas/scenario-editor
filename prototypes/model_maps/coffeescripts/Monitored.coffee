class window.aurora.Monitored extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Monitored()
    links = xml.children('links')
    obj.set('links', $a.Links.from_xml2(links, deferred, object_with_id))
    nodes = xml.children('nodes')
    obj.set('nodes', $a.Nodes.from_xml2(nodes, deferred, object_with_id))
    monitors = xml.children('monitors')
    obj.set('monitors', $a.Monitors.from_xml2(monitors, deferred, object_with_id))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('monitored')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('links').to_xml(doc)) if @has('links')
    xml.appendChild(@get('nodes').to_xml(doc)) if @has('nodes')
    xml.appendChild(@get('monitors').to_xml(doc)) if @has('monitors')
    xml
  
  deep_copy: -> Monitored.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null