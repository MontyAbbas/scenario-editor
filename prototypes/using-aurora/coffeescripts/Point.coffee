class window.aurora.Point extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Point()
    lat = xml.find('lat')
    obj.set 'lat', Number(lat)
    lng = xml.find('lng')
    obj.set 'lng', Number(lng)
    elevation = xml.find('elevation')
    obj.set 'elevation', Number(elevation)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('point')
    if @encode_references
      @encode_references()
    xml.setAttribute('lat', @get('lat'))
    xml.setAttribute('lng', @get('lng'))
    if @has('elevation') && @elevation != 0 then xml.setAttribute('elevation', @get('elevation'))
    xml
  
  deep_copy: -> Point.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null