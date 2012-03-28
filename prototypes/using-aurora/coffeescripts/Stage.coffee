class window.aurora.Stage extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Stage()
    greentime = $(xml).attr('greentime')
    obj.set 'greentime', Number(greentime)
    movA = $(xml).attr('movA')
    obj.set 'movA', xml.movA
    movB = $(xml).attr('movB')
    obj.set 'movB', xml.movB
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('stage')
    if @encode_references
      @encode_references()
    xml.setAttribute('greentime', @get('greentime'))
    xml.setAttribute('movA', @get('movA'))
    xml.setAttribute('movB', @get('movB'))
    xml
  
  deep_copy: -> Stage.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null