class window.sirius.Splitratio extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Splitratio()
    link_in = $(xml).attr('link_in')
    obj.set('link_in', link_in)
    link_out = $(xml).attr('link_out')
    obj.set('link_out', link_out)
    obj.set('text', xml.text())
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('splitratio')
    if @encode_references
      @encode_references()
    xml.setAttribute('link_in', @get('link_in')) if @has('link_in')
    xml.setAttribute('link_out', @get('link_out')) if @has('link_out')
    xml.appendChild(doc.createTextNode($a.ArrayText.emit(@get('text') || [])))
    xml
  
  deep_copy: -> Splitratio.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null