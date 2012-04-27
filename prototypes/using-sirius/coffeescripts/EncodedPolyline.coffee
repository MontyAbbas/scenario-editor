class window.sirius.EncodedPolyline extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.EncodedPolyline()
    Points = xml.children('Points')
    obj.set('points', $a.Points.from_xml2(Points, deferred, object_with_id))
    Levels = xml.children('Levels')
    obj.set('levels', $a.Levels.from_xml2(Levels, deferred, object_with_id))
    zoomFactor = $(xml).attr('zoomFactor')
    obj.set('zoomFactor', Number(zoomFactor))
    numLevels = $(xml).attr('numLevels')
    obj.set('numLevels', Number(numLevels))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('EncodedPolyline')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('points').to_xml(doc)) if @has('points')
    xml.appendChild(@get('levels').to_xml(doc)) if @has('levels')
    xml.setAttribute('zoomFactor', @get('zoomFactor')) if @has('zoomFactor')
    xml.setAttribute('numLevels', @get('numLevels')) if @has('numLevels')
    xml
  
  deep_copy: -> EncodedPolyline.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null