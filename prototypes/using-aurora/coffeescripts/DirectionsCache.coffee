class window.aurora.DirectionsCache extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.DirectionsCache()
    DirectionsCacheEntry = xml.find('DirectionsCacheEntry')
    obj.set 'directionscacheentry', _.map(DirectionsCacheEntry, (DirectionsCacheEntry_i) -> $a.DirectionsCacheEntry.from_xml2(DirectionsCacheEntry_i, deferred, object_with_id))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('DirectionsCache')
    if @encode_references
      @encode_references()
    _.each(@get('directionscacheentry') || [], (a_directionscacheentry) -> xml.appendChild(a_directionscacheentry.to_xml()))
    xml
  
  deep_copy: -> DirectionsCache.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null