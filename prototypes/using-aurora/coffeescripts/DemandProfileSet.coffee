class window.aurora.DemandProfileSet extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.DemandProfileSet()
    description = xml.find('description')
    obj.set 'description', $a.Description.from_xml2(description, deferred, object_with_id)
    demand = xml.find('demand')
    obj.set 'demand', _.map(demand, (demand_i) -> $a.Demand.from_xml2(demand_i, deferred, object_with_id))
    id = xml.find('id')
    obj.set 'id', (id.length() == 0 ? "" : id)
    name = xml.find('name')
    obj.set 'name', (name.length() == 0 ? "" : name)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('DemandProfileSet')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml()) if @has('description')
    _.each(@get('demand') || [], (a_demand) -> xml.appendChild(a_demand.to_xml()))
    if @has('id') && @id != "" then xml.setAttribute('id', @get('id'))
    if @has('name') && @name != "" then xml.setAttribute('name', @get('name'))
    xml
  
  deep_copy: -> DemandProfileSet.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null