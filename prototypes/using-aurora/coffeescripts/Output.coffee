class window.aurora.Output extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Output()
    link_id = $(xml).attr('link_id')
    obj.set('link_id', link_id)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('output')
    if @encode_references
      @encode_references()
    xml.setAttribute('link_id', @get('link_id')) if @has('link_id')
    xml
  
  deep_copy: -> Output.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null