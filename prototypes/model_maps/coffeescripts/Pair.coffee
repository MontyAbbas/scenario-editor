class window.aurora.Pair extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Pair()
    outlink = $(xml).attr('outlink')
    obj.set('outlink', outlink)
    inlink = $(xml).attr('inlink')
    obj.set('inlink', inlink)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('pair')
    if @encode_references
      @encode_references()
    xml.setAttribute('outlink', @get('outlink')) if @has('outlink')
    xml.setAttribute('inlink', @get('inlink')) if @has('inlink')
    xml
  
  deep_copy: -> Pair.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null