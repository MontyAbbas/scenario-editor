class window.aurora.Srm extends Backbone.Model
  @dim = 3
  @delims = [";", ",", ":"]
  @cell_type = "Number"
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Srm()
    
    obj.set('cells', $a.ArrayText.parse(xml.text(), @delims, "Number", null))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('srm')
    if @encode_references
      @encode_references()
    xml.appendChild(doc.createTextNode($a.ArrayText.emit(@get('cells') || [], @delims)))
    xml
  
  deep_copy: -> Srm.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null