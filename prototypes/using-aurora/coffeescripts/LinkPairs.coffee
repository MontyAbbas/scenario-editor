class window.aurora.LinkPairs extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.LinkPairs()
    pair = xml.find('pair')
    obj.set 'pair', _.map(pair, (pair_i) -> $a.Pair.from_xml2(pair_i, deferred, object_with_id))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('LinkPairs')
    if @encode_references
      @encode_references()
    _.each(@get('pair') || [], (a_pair) -> xml.appendChild(a_pair.to_xml()))
    xml
  
  deep_copy: -> LinkPairs.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null