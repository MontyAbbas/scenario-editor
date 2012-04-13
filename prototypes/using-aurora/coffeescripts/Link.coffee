class window.aurora.Link extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Link()
    description = xml.children('description')
    obj.set('description', $a.Description.from_xml2(description, deferred, object_with_id))
    begin = xml.children('begin')
    obj.set('begin', $a.Begin.from_xml2(begin, deferred, object_with_id))
    end = xml.children('end')
    obj.set('end', $a.End.from_xml2(end, deferred, object_with_id))
    fd = xml.children('fd')
    obj.set('fd', $a.Fd.from_xml2(fd, deferred, object_with_id))
    dynamics = xml.children('dynamics')
    obj.set('dynamics', $a.Dynamics.from_xml2(dynamics, deferred, object_with_id))
    qmax = xml.children('qmax')
    obj.set('qmax', $a.Qmax.from_xml2(qmax, deferred, object_with_id))
    LinkGeometry = xml.children('LinkGeometry')
    obj.set('linkgeometry', $a.LinkGeometry.from_xml2(LinkGeometry, deferred, object_with_id))
    name = $(xml).attr('name')
    obj.set('name', name)
    road_name = $(xml).attr('road_name')
    obj.set('road_name', road_name)
    lanes = $(xml).attr('lanes')
    obj.set('lanes', Number(lanes))
    lane_offset = $(xml).attr('lane_offset')
    obj.set('lane_offset', Number(lane_offset))
    length = $(xml).attr('length')
    obj.set('length', Number(length))
    type = $(xml).attr('type')
    obj.set('type', type)
    id = $(xml).attr('id')
    obj.set('id', id)
    record = $(xml).attr('record')
    obj.set('record', (record.toString().toLowerCase() == 'true') if record?)
    if object_with_id.link
      object_with_id.link[obj.id] = obj
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('link')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml(doc)) if @has('description')
    xml.appendChild(@get('begin').to_xml(doc)) if @has('begin')
    xml.appendChild(@get('end').to_xml(doc)) if @has('end')
    xml.appendChild(@get('fd').to_xml(doc)) if @has('fd')
    xml.appendChild(@get('dynamics').to_xml(doc)) if @has('dynamics')
    xml.appendChild(@get('qmax').to_xml(doc)) if @has('qmax')
    xml.appendChild(@get('linkgeometry').to_xml(doc)) if @has('linkgeometry')
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('road_name', @get('road_name')) if @has('road_name')
    xml.setAttribute('lanes', @get('lanes')) if @has('lanes')
    if @has('lane_offset') && @lane_offset != 0 then xml.setAttribute('lane_offset', @get('lane_offset'))
    xml.setAttribute('length', @get('length')) if @has('length')
    xml.setAttribute('type', @get('type')) if @has('type')
    xml.setAttribute('id', @get('id')) if @has('id')
    if @has('record') && @record != true then xml.setAttribute('record', @get('record'))
    xml
  
  deep_copy: -> Link.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null