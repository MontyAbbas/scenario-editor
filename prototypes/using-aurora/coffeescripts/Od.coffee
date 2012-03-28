class window.aurora.Od extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Od()
    PathList = xml.find('PathList')
    obj.set 'pathlist', $a.PathList.from_xml2(PathList, deferred, object_with_id)
    begin = $(xml).attr('begin')
    obj.set 'begin', xml.begin
    end = $(xml).attr('end')
    obj.set 'end', xml.end
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('od')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('pathlist').to_xml()) if @has('pathlist')
    xml.setAttribute('begin', @get('begin'))
    xml.setAttribute('end', @get('end'))
    xml
  
  deep_copy: -> Od.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null