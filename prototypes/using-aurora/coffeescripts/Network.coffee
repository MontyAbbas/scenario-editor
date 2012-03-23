class window.aurora.Network extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Network()
    description = xml.find('description')
    obj.set 'description', $a.Description.from_xml2(description, deferred, object_with_id)
    position = xml.find('position')
    obj.set 'position', $a.Position.from_xml2(position, deferred, object_with_id)
    MonitorList = xml.find('MonitorList')
    obj.set 'monitorlist', $a.MonitorList.from_xml2(MonitorList, deferred, object_with_id)
    NetworkList = xml.find('NetworkList')
    obj.set 'networklist', $a.NetworkList.from_xml2(NetworkList, deferred, object_with_id)
    NodeList = xml.find('NodeList')
    obj.set 'nodelist', $a.NodeList.from_xml2(NodeList, deferred, object_with_id)
    LinkList = xml.find('LinkList')
    obj.set 'linklist', $a.LinkList.from_xml2(LinkList, deferred, object_with_id)
    SignalList = xml.find('SignalList')
    obj.set 'signallist', $a.SignalList.from_xml2(SignalList, deferred, object_with_id)
    ODList = xml.find('ODList')
    obj.set 'odlist', $a.ODList.from_xml2(ODList, deferred, object_with_id)
    SensorList = xml.find('SensorList')
    obj.set 'sensorlist', $a.SensorList.from_xml2(SensorList, deferred, object_with_id)
    DirectionsCache = xml.find('DirectionsCache')
    obj.set 'directionscache', $a.DirectionsCache.from_xml2(DirectionsCache, deferred, object_with_id)
    IntersectionCache = xml.find('IntersectionCache')
    obj.set 'intersectioncache', $a.IntersectionCache.from_xml2(IntersectionCache, deferred, object_with_id)
    name = xml.find('name')
    obj.set 'name', xml.name
    ml_control = xml.find('ml_control')
    obj.set 'ml_control', (ml_control.toString().toLowerCase() == 'true')
    q_control = xml.find('q_control')
    obj.set 'q_control', (q_control.toString().toLowerCase() == 'true')
    dt = xml.find('dt')
    obj.set 'dt', Number(dt)
    id = xml.find('id')
    obj.set 'id', xml.id
    if object_with_id.network
      object_with_id.network[obj.id] = obj
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('network')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml()) if @has('description')
    xml.appendChild(@get('position').to_xml()) if @has('position')
    xml.appendChild(@get('monitorlist').to_xml()) if @has('monitorlist')
    xml.appendChild(@get('networklist').to_xml()) if @has('networklist')
    xml.appendChild(@get('nodelist').to_xml()) if @has('nodelist')
    xml.appendChild(@get('linklist').to_xml()) if @has('linklist')
    xml.appendChild(@get('signallist').to_xml()) if @has('signallist')
    xml.appendChild(@get('odlist').to_xml()) if @has('odlist')
    xml.appendChild(@get('sensorlist').to_xml()) if @has('sensorlist')
    xml.appendChild(@get('directionscache').to_xml()) if @has('directionscache')
    xml.appendChild(@get('intersectioncache').to_xml()) if @has('intersectioncache')
    xml.setAttribute('name', @get('name'))
    xml.setAttribute('ml_control', @get('ml_control'))
    xml.setAttribute('q_control', @get('q_control'))
    xml.setAttribute('dt', @get('dt'))
    xml.setAttribute('id', @get('id'))
    xml
  
  deep_copy: -> Network.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null