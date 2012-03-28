class window.aurora.CapacityProfileSet extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.CapacityProfileSet()
    description = xml.find('description')
    obj.set 'description', $a.Description.from_xml2(description, deferred, object_with_id)
    capacity = xml.find('capacity')
    obj.set 'capacity', _.map(capacity, (capacity_i) -> $a.Capacity.from_xml2(capacity_i, deferred, object_with_id))
    id = $(xml).attr('id')
    obj.set 'id', (id.length() == 0 ? "" : id)
    name = $(xml).attr('name')
    obj.set 'name', (name.length() == 0 ? "" : name)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('CapacityProfileSet')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml()) if @has('description')
    _.each(@get('capacity') || [], (a_capacity) -> xml.appendChild(a_capacity.to_xml()))
    if @has('id') && @id != "" then xml.setAttribute('id', @get('id'))
    if @has('name') && @name != "" then xml.setAttribute('name', @get('name'))
    xml
  
  deep_copy: -> CapacityProfileSet.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null