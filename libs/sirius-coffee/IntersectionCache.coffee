class window.sirius.IntersectionCache extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.IntersectionCache()
    IntersectionCacheEntry = xml.children('IntersectionCacheEntry')
    obj.set('intersectioncacheentry', _.map($(IntersectionCacheEntry), (IntersectionCacheEntry_i) -> $a.IntersectionCacheEntry.from_xml2($(IntersectionCacheEntry_i), deferred, object_with_id)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('IntersectionCache')
    if @encode_references
      @encode_references()
    _.each(@get('intersectioncacheentry') || [], (a_intersectioncacheentry) -> xml.appendChild(a_intersectioncacheentry.to_xml(doc)))
    xml
  
  deep_copy: -> IntersectionCache.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null