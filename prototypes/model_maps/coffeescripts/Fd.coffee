class window.aurora.Fd extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Fd()
    densityCritical = $(xml).attr('densityCritical')
    obj.set('densityCritical', densityCritical)
    flowMax = $(xml).attr('flowMax')
    obj.set('flowMax', flowMax)
    densityJam = $(xml).attr('densityJam')
    obj.set('densityJam', densityJam)
    capacityDrop = $(xml).attr('capacityDrop')
    obj.set('capacityDrop', Number(capacityDrop))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('fd')
    if @encode_references
      @encode_references()
    xml.setAttribute('densityCritical', @get('densityCritical')) if @has('densityCritical')
    xml.setAttribute('flowMax', @get('flowMax')) if @has('flowMax')
    xml.setAttribute('densityJam', @get('densityJam')) if @has('densityJam')
    if @has('capacityDrop') && @capacityDrop != 0.0 then xml.setAttribute('capacityDrop', @get('capacityDrop'))
    xml
  
  deep_copy: -> Fd.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null