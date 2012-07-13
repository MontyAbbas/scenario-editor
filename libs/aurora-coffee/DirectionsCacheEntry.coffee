class window.aurora.DirectionsCacheEntry extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.DirectionsCacheEntry()
    From = xml.children('From')
    obj.set('from', $a.From.from_xml2(From, deferred, object_with_id))
    To = xml.children('To')
    obj.set('to', $a.To.from_xml2(To, deferred, object_with_id))
    EncodedPolyline = xml.children('EncodedPolyline')
    obj.set('encodedpolyline', $a.EncodedPolyline.from_xml2(EncodedPolyline, deferred, object_with_id))
    avoidHighways = $(xml).attr('avoidHighways')
    obj.set('avoidHighways', (avoidHighways.toString().toLowerCase() == 'true') if avoidHighways?)
    road_name = $(xml).attr('road_name')
    obj.set('road_name', road_name)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('DirectionsCacheEntry')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('from').to_xml(doc)) if @has('from')
    xml.appendChild(@get('to').to_xml(doc)) if @has('to')
    xml.appendChild(@get('encodedpolyline').to_xml(doc)) if @has('encodedpolyline')
    xml.setAttribute('avoidHighways', @get('avoidHighways')) if @has('avoidHighways')
    xml.setAttribute('road_name', @get('road_name')) if @has('road_name')
    xml
  
  deep_copy: -> DirectionsCacheEntry.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null