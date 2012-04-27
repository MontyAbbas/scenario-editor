class window.sirius.EventSet extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.EventSet()
    description = xml.children('description')
    obj.set('description', $a.Description.from_xml2(description, deferred, object_with_id))
    event = xml.children('event')
    obj.set('event', _.map($(event), (event_i) -> $a.Event.from_xml2($(event_i), deferred, object_with_id)))
    id = $(xml).attr('id')
    obj.set('id', id)
    name = $(xml).attr('name')
    obj.set('name', name)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('EventSet')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml(doc)) if @has('description')
    _.each(@get('event') || [], (a_event) -> xml.appendChild(a_event.to_xml(doc)))
    if @has('id') && @id != "" then xml.setAttribute('id', @get('id'))
    if @has('name') && @name != "" then xml.setAttribute('name', @get('name'))
    xml
  
  deep_copy: -> EventSet.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null