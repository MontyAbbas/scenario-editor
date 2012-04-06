class window.aurora.Wfm extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Wfm()
    weavingfactors = xml.children('weavingfactors')
    obj.set('weavingfactors', _.map($(weavingfactors), (weavingfactors_i) -> $a.Weavingfactors.from_xml2($(weavingfactors_i), deferred, object_with_id)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('wfm')
    if @encode_references
      @encode_references()
    _.each(@get('weavingfactors') || [], (a_weavingfactors) -> xml.appendChild(a_weavingfactors.to_xml(doc)))
    xml
  
  deep_copy: -> Wfm.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null