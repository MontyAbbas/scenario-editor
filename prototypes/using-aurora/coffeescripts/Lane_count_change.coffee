class window.aurora.Lane_count_change extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Lane_count_change()
    reset_to_nominal = $(xml).attr('reset_to_nominal')
    obj.set('reset_to_nominal', (reset_to_nominal.toString().toLowerCase() == 'true') if reset_to_nominal?)
    delta = $(xml).attr('delta')
    obj.set('delta', Number(delta))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('lane_count_change')
    if @encode_references
      @encode_references()
    if @has('reset_to_nominal') && @reset_to_nominal != false then xml.setAttribute('reset_to_nominal', @get('reset_to_nominal'))
    if @has('delta') && @delta != 0 then xml.setAttribute('delta', @get('delta'))
    xml
  
  deep_copy: -> Lane_count_change.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null