class window.aurora.Monitor extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Monitor()
    monitored = xml.children('monitored')
    obj.set('monitored', $a.Monitored.from_xml2(monitored, deferred, object_with_id))
    controlled = xml.children('controlled')
    obj.set('controlled', $a.Controlled.from_xml2(controlled, deferred, object_with_id))
    controller = xml.children('controller')
    obj.set('controller', $a.Controller.from_xml2(controller, deferred, object_with_id))
    LinkPairs = xml.children('LinkPairs')
    obj.set('linkpairs', $a.LinkPairs.from_xml2(LinkPairs, deferred, object_with_id))
    name = $(xml).attr('name')
    obj.set('name', name)
    type = $(xml).attr('type')
    obj.set('type', type)
    id = $(xml).attr('id')
    obj.set('id', id)
    obj.set('text', xml.text())
    if object_with_id.monitor
      object_with_id.monitor[obj.id] = obj
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('monitor')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('monitored').to_xml(doc)) if @has('monitored')
    xml.appendChild(@get('controlled').to_xml(doc)) if @has('controlled')
    xml.appendChild(@get('controller').to_xml(doc)) if @has('controller')
    xml.appendChild(@get('linkpairs').to_xml(doc)) if @has('linkpairs')
    if @has('name') && @name != "" then xml.setAttribute('name', @get('name'))
    xml.setAttribute('type', @get('type')) if @has('type')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.appendChild(doc.createTextNode($a.ArrayText.emit(@get('text') || [])))
    xml
  
  deep_copy: -> Monitor.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null