class window.aurora.Zones extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Zones()
    zone = xml.children('zone')
    obj.set('zone', _.map($(zone), (zone_i) -> $a.Zone.from_xml2($(zone_i), deferred, object_with_id)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('zones')
    if @encode_references
      @encode_references()
    _.each(@get('zone') || [], (a_zone) -> xml.appendChild(a_zone.to_xml(doc)))
    xml
  
  deep_copy: -> Zones.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null