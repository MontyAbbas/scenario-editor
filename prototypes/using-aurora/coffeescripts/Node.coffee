class window.aurora.Node extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Node()
    description = xml.find('description')
    obj.set 'description', $a.Description.from_xml2(description, deferred, object_with_id)
    postmile = xml.find('postmile')
    obj.set 'postmile', $a.Postmile.from_xml2(postmile, deferred, object_with_id)
    outputs = xml.find('outputs')
    obj.set 'outputs', $a.Outputs.from_xml2(outputs, deferred, object_with_id)
    inputs = xml.find('inputs')
    obj.set 'inputs', $a.Inputs.from_xml2(inputs, deferred, object_with_id)
    position = xml.find('position')
    obj.set 'position', $a.Position.from_xml2(position, deferred, object_with_id)
    name = xml.find('name')
    obj.set 'name', xml.name
    type = xml.find('type')
    obj.set 'type', xml.type
    id = xml.find('id')
    obj.set 'id', xml.id
    lock = xml.find('lock')
    obj.set 'lock', (lock.toString().toLowerCase() == 'true')
    if object_with_id.node
      object_with_id.node[obj.id] = obj
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('node')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml()) if @has('description')
    xml.appendChild(@get('postmile').to_xml()) if @has('postmile')
    xml.appendChild(@get('outputs').to_xml()) if @has('outputs')
    xml.appendChild(@get('inputs').to_xml()) if @has('inputs')
    xml.appendChild(@get('position').to_xml()) if @has('position')
    xml.setAttribute('name', @get('name'))
    xml.setAttribute('type', @get('type'))
    xml.setAttribute('id', @get('id'))
    if @has('lock') && @lock != false then xml.setAttribute('lock', @get('lock'))
    xml
  
  deep_copy: -> Node.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null