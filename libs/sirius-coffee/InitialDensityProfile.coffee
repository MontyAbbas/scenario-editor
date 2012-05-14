class window.sirius.InitialDensityProfile extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.InitialDensityProfile()
    description = xml.children('description')
    obj.set('description', $a.Description.from_xml2(description, deferred, object_with_id))
    VehicleTypeOrder = xml.children('VehicleTypeOrder')
    obj.set('vehicletypeorder', $a.VehicleTypeOrder.from_xml2(VehicleTypeOrder, deferred, object_with_id))
    density = xml.children('density')
    obj.set('density', _.map($(density), (density_i) -> $a.Density.from_xml2($(density_i), deferred, object_with_id)))
    id = $(xml).attr('id')
    obj.set('id', id)
    name = $(xml).attr('name')
    obj.set('name', name)
    tstamp = $(xml).attr('tstamp')
    obj.set('tstamp', Number(tstamp))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('InitialDensityProfile')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml(doc)) if @has('description')
    xml.appendChild(@get('vehicletypeorder').to_xml(doc)) if @has('vehicletypeorder')
    _.each(@get('density') || [], (a_density) -> xml.appendChild(a_density.to_xml(doc)))
    if @has('id') && @id != "" then xml.setAttribute('id', @get('id'))
    if @has('name') && @name != "" then xml.setAttribute('name', @get('name'))
    xml.setAttribute('tstamp', @get('tstamp')) if @has('tstamp')
    xml
  
  deep_copy: -> InitialDensityProfile.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null