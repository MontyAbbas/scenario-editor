class window.aurora.Zone extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Zone()
    bottlenecklink = $(xml).attr('bottlenecklink')
    obj.set('bottlenecklink', bottlenecklink)
    onramplinks = $(xml).attr('onramplinks')
    obj.set('onramplinks', onramplinks)
    sat_den_multiplier = $(xml).attr('sat_den_multiplier')
    obj.set('sat_den_multiplier', Number(sat_den_multiplier))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('zone')
    if @encode_references
      @encode_references()
    xml.setAttribute('bottlenecklink', @get('bottlenecklink')) if @has('bottlenecklink')
    xml.setAttribute('onramplinks', @get('onramplinks')) if @has('onramplinks')
    xml.setAttribute('sat_den_multiplier', @get('sat_den_multiplier')) if @has('sat_den_multiplier')
    xml
  
  deep_copy: -> Zone.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null