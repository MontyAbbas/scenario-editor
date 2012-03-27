class window.aurora.Capacity extends Backbone.Model
  @dim = 1
  @delims = [","]
  @cell_type = "Number"
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Capacity()
    link_id = xml.find('link_id')
    obj.set 'link_id', xml.link_id
    start_time = xml.find('start_time')
    obj.set 'start_time', Number(start_time)
    dt = xml.find('dt')
    obj.set 'dt', Number(dt)
    
    obj.set 'cells', $a.ArrayText.parse(xml.text(), delims, "Number", null)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('capacity')
    if @encode_references
      @encode_references()
    xml.setAttribute('link_id', @get('link_id'))
    if @has('start_time') && @start_time != 0 then xml.setAttribute('start_time', @get('start_time'))
    xml.setAttribute('dt', @get('dt'))
    xml.appendChild(doc.createTextNode($a.ArrayText.emit(@get('cells') || [], @delims)))
    xml
  
  deep_copy: -> Capacity.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null