class window.aurora.Monitor extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Monitor()
    monitored = xml.find('monitored')
    obj.set 'monitored', $a.Monitored.from_xml2(monitored, deferred, object_with_id)
    controlled = xml.find('controlled')
    obj.set 'controlled', $a.Controlled.from_xml2(controlled, deferred, object_with_id)
    controller = xml.find('controller')
    obj.set 'controller', $a.Controller.from_xml2(controller, deferred, object_with_id)
    LinkPairs = xml.find('LinkPairs')
    obj.set 'linkpairs', $a.LinkPairs.from_xml2(LinkPairs, deferred, object_with_id)
    name = xml.find('name')
    obj.set 'name', (name.length() == 0 ? "" : name)
    type = xml.find('type')
    obj.set 'type', xml.type
    id = xml.find('id')
    obj.set 'id', xml.id
    
    obj.set 'text', xml.text()
    if object_with_id.monitor
      object_with_id.monitor[obj.id] = obj
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('monitor')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('monitored').to_xml()) if @has('monitored')
    xml.appendChild(@get('controlled').to_xml()) if @has('controlled')
    xml.appendChild(@get('controller').to_xml()) if @has('controller')
    xml.appendChild(@get('linkpairs').to_xml()) if @has('linkpairs')
    if @has('name') && @name != "" then xml.setAttribute('name', @get('name'))
    xml.setAttribute('type', @get('type'))
    xml.setAttribute('id', @get('id'))
    xml.appendChild(doc.createTextNode($a.ArrayText.emit(@get('text') || [])))
    xml
  
  deep_copy: -> Monitor.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null