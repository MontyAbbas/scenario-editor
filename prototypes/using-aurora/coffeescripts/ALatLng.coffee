class window.aurora.ALatLng extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.ALatLng()
    lat = $(xml).attr('lat')
    obj.set('lat', Number(lat))
    lng = $(xml).attr('lng')
    obj.set('lng', Number(lng))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('ALatLng')
    if @encode_references
      @encode_references()
    xml.setAttribute('lat', @get('lat')) if @has('lat')
    xml.setAttribute('lng', @get('lng')) if @has('lng')
    xml
  
  deep_copy: -> ALatLng.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null