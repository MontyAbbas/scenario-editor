class window.aurora.Source extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Source()
    url = $(xml).attr('url')
    obj.set 'url', xml.url
    dt = $(xml).attr('dt')
    obj.set 'dt', Number(dt)
    format = $(xml).attr('format')
    obj.set 'format', xml.format
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('source')
    if @encode_references
      @encode_references()
    xml.setAttribute('url', @get('url'))
    xml.setAttribute('dt', @get('dt'))
    xml.setAttribute('format', @get('format'))
    xml
  
  deep_copy: -> Source.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null