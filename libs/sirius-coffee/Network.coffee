class window.sirius.Network extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Network()
    description = xml.children('description')
    obj.set('description', $a.Description.from_xml2(description, deferred, object_with_id))
    position = xml.children('position')
    obj.set('position', $a.Position.from_xml2(position, deferred, object_with_id))
    NodeList = xml.children('NodeList')
    obj.set('nodelist', $a.NodeList.from_xml2(NodeList, deferred, object_with_id))
    LinkList = xml.children('LinkList')
    obj.set('linklist', $a.LinkList.from_xml2(LinkList, deferred, object_with_id))
    SignalList = xml.children('SignalList')
    obj.set('signallist', $a.SignalList.from_xml2(SignalList, deferred, object_with_id))
    SensorList = xml.children('SensorList')
    obj.set('sensorlist', $a.SensorList.from_xml2(SensorList, deferred, object_with_id))
    DirectionsCache = xml.children('DirectionsCache')
    obj.set('directionscache', $a.DirectionsCache.from_xml2(DirectionsCache, deferred, object_with_id))
    IntersectionCache = xml.children('IntersectionCache')
    obj.set('intersectioncache', $a.IntersectionCache.from_xml2(IntersectionCache, deferred, object_with_id))
    name = $(xml).attr('name')
    obj.set('name', name)
    dt = $(xml).attr('dt')
    obj.set('dt', Number(dt))
    id = $(xml).attr('id')
    obj.set('id', id)
    if object_with_id.network
      object_with_id.network[obj.id] = obj
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('network')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml(doc)) if @has('description')
    xml.appendChild(@get('position').to_xml(doc)) if @has('position')
    xml.appendChild(@get('nodelist').to_xml(doc)) if @has('nodelist')
    xml.appendChild(@get('linklist').to_xml(doc)) if @has('linklist')
    xml.appendChild(@get('signallist').to_xml(doc)) if @has('signallist')
    xml.appendChild(@get('sensorlist').to_xml(doc)) if @has('sensorlist')
    xml.appendChild(@get('directionscache').to_xml(doc)) if @has('directionscache')
    xml.appendChild(@get('intersectioncache').to_xml(doc)) if @has('intersectioncache')
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('dt', @get('dt')) if @has('dt')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml
  
  deep_copy: -> Network.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null