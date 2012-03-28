class window.aurora.Limits extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Limits()
    cmin = $(xml).attr('cmin')
    obj.set 'cmin', Number(cmin)
    cmax = $(xml).attr('cmax')
    obj.set 'cmax', Number(cmax)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('limits')
    if @encode_references
      @encode_references()
    xml.setAttribute('cmin', @get('cmin'))
    xml.setAttribute('cmax', @get('cmax'))
    xml
  
  deep_copy: -> Limits.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null