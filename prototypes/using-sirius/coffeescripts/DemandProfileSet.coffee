class window.sirius.DemandProfileSet extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.DemandProfileSet()
    description = xml.children('description')
    obj.set('description', $a.Description.from_xml2(description, deferred, object_with_id))
    VehicleTypeOrder = xml.children('VehicleTypeOrder')
    obj.set('vehicletypeorder', $a.VehicleTypeOrder.from_xml2(VehicleTypeOrder, deferred, object_with_id))
    demandProfile = xml.children('demandProfile')
    obj.set('demandprofile', _.map($(demandProfile), (demandProfile_i) -> $a.DemandProfile.from_xml2($(demandProfile_i), deferred, object_with_id)))
    id = $(xml).attr('id')
    obj.set('id', id)
    name = $(xml).attr('name')
    obj.set('name', name)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('DemandProfileSet')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml(doc)) if @has('description')
    xml.appendChild(@get('vehicletypeorder').to_xml(doc)) if @has('vehicletypeorder')
    _.each(@get('demandprofile') || [], (a_demandprofile) -> xml.appendChild(a_demandprofile.to_xml(doc)))
    if @has('id') && @id != "" then xml.setAttribute('id', @get('id'))
    if @has('name') && @name != "" then xml.setAttribute('name', @get('name'))
    xml
  
  deep_copy: -> DemandProfileSet.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null