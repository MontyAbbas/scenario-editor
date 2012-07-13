class window.sirius.Data_source extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Data_source()
    url = $(xml).attr('url')
    obj.set('url', url)
    dt = $(xml).attr('dt')
    obj.set('dt', Number(dt))
    format = $(xml).attr('format')
    obj.set('format', format)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('data_source')
    if @encode_references
      @encode_references()
    xml.setAttribute('url', @get('url')) if @has('url')
    xml.setAttribute('dt', @get('dt')) if @has('dt')
    xml.setAttribute('format', @get('format')) if @has('format')
    xml
  
  deep_copy: -> Data_source.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null