class window.aurora.Pair extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Pair()
    outlink = xml.find('outlink')
    obj.set 'outlink', xml.outlink
    inlink = xml.find('inlink')
    obj.set 'inlink', xml.inlink
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('pair')
    if @encode_references
      @encode_references()
    xml.setAttribute('outlink', @get('outlink'))
    xml.setAttribute('inlink', @get('inlink'))
    xml
  
  deep_copy: -> Pair.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null