class window.sirius.Linkpair extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Linkpair()
    link_a = $(xml).attr('link_a')
    obj.set('link_a', link_a)
    link_b = $(xml).attr('link_b')
    obj.set('link_b', link_b)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('linkpair')
    if @encode_references
      @encode_references()
    xml.setAttribute('link_a', @get('link_a')) if @has('link_a')
    xml.setAttribute('link_b', @get('link_b')) if @has('link_b')
    xml
  
  deep_copy: -> Linkpair.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null