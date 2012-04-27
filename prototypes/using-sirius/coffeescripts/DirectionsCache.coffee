class window.sirius.DirectionsCache extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.DirectionsCache()
    DirectionsCacheEntry = xml.children('DirectionsCacheEntry')
    obj.set('directionscacheentry', _.map($(DirectionsCacheEntry), (DirectionsCacheEntry_i) -> $a.DirectionsCacheEntry.from_xml2($(DirectionsCacheEntry_i), deferred, object_with_id)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('DirectionsCache')
    if @encode_references
      @encode_references()
    _.each(@get('directionscacheentry') || [], (a_directionscacheentry) -> xml.appendChild(a_directionscacheentry.to_xml(doc)))
    xml
  
  deep_copy: -> DirectionsCache.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null