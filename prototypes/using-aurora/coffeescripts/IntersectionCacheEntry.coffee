class window.aurora.IntersectionCacheEntry extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.IntersectionCacheEntry()
    qlat = xml.find('qlat')
    obj.set 'qlat', Number(qlat)
    qlng = xml.find('qlng')
    obj.set 'qlng', Number(qlng)
    lat = xml.find('lat')
    obj.set 'lat', Number(lat)
    lng = xml.find('lng')
    obj.set 'lng', Number(lng)
    street1 = xml.find('street1')
    obj.set 'street1', xml.street1
    street2 = xml.find('street2')
    obj.set 'street2', xml.street2
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('IntersectionCacheEntry')
    if @encode_references
      @encode_references()
    xml.setAttribute('qlat', @get('qlat'))
    xml.setAttribute('qlng', @get('qlng'))
    xml.setAttribute('lat', @get('lat'))
    xml.setAttribute('lng', @get('lng'))
    xml.setAttribute('street1', @get('street1'))
    xml.setAttribute('street2', @get('street2'))
    xml
  
  deep_copy: -> IntersectionCacheEntry.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null