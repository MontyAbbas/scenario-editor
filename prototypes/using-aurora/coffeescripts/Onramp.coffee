class window.aurora.Onramp extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Onramp()
    id = $(xml).attr('id')
    obj.set('id', id)
    gain_Alinea = $(xml).attr('gain_Alinea')
    obj.set('gain_Alinea', Number(gain_Alinea))
    gain_Hero = $(xml).attr('gain_Hero')
    obj.set('gain_Hero', Number(gain_Hero))
    activation_threshold = $(xml).attr('activation_threshold')
    obj.set('activation_threshold', Number(activation_threshold))
    deactivation_threshold = $(xml).attr('deactivation_threshold')
    obj.set('deactivation_threshold', Number(deactivation_threshold))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('onramp')
    if @encode_references
      @encode_references()
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('gain_Alinea', @get('gain_Alinea')) if @has('gain_Alinea')
    xml.setAttribute('gain_Hero', @get('gain_Hero')) if @has('gain_Hero')
    xml.setAttribute('activation_threshold', @get('activation_threshold')) if @has('activation_threshold')
    xml.setAttribute('deactivation_threshold', @get('deactivation_threshold')) if @has('deactivation_threshold')
    xml
  
  deep_copy: -> Onramp.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null