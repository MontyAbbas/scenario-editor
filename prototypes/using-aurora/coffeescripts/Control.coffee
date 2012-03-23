class window.aurora.Control extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Control()
    mainline = xml.find('mainline')
    obj.set 'mainline', (mainline.toString().toLowerCase() == 'true')
    queue = xml.find('queue')
    obj.set 'queue', (queue.toString().toLowerCase() == 'true')
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('control')
    if @encode_references
      @encode_references()
    xml.setAttribute('mainline', @get('mainline'))
    xml.setAttribute('queue', @get('queue'))
    xml
  
  deep_copy: -> Control.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null