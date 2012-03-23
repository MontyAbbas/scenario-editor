class window.aurora.ControllerSet extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.ControllerSet()
    description = xml.find('description')
    obj.set 'description', $a.Description.from_xml2(description, deferred, object_with_id)
    controller = xml.find('controller')
    obj.set 'controller', _.map(controller, (controller_i) -> $a.Controller.from_xml2(controller_i, deferred, object_with_id))
    id = xml.find('id')
    obj.set 'id', (id.length() == 0 ? "" : id)
    name = xml.find('name')
    obj.set 'name', (name.length() == 0 ? "" : name)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('ControllerSet')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml()) if @has('description')
    _.each(@get('controller') || [], (a_controller) -> xml.appendChild(a_controller.to_xml()))
    if @has('id') && @id != "" then xml.setAttribute('id', @get('id'))
    if @has('name') && @name != "" then xml.setAttribute('name', @get('name'))
    xml
  
  deep_copy: -> ControllerSet.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null