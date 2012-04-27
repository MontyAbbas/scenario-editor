class window.sirius.SplitRatioProfileSet extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.SplitRatioProfileSet()
    description = xml.children('description')
    obj.set('description', $a.Description.from_xml2(description, deferred, object_with_id))
    VehicleTypeOrder = xml.children('VehicleTypeOrder')
    obj.set('vehicletypeorder', $a.VehicleTypeOrder.from_xml2(VehicleTypeOrder, deferred, object_with_id))
    splitratioProfile = xml.children('splitratioProfile')
    obj.set('splitratioprofile', _.map($(splitratioProfile), (splitratioProfile_i) -> $a.SplitratioProfile.from_xml2($(splitratioProfile_i), deferred, object_with_id)))
    id = $(xml).attr('id')
    obj.set('id', id)
    name = $(xml).attr('name')
    obj.set('name', name)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('SplitRatioProfileSet')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml(doc)) if @has('description')
    xml.appendChild(@get('vehicletypeorder').to_xml(doc)) if @has('vehicletypeorder')
    _.each(@get('splitratioprofile') || [], (a_splitratioprofile) -> xml.appendChild(a_splitratioprofile.to_xml(doc)))
    if @has('id') && @id != "" then xml.setAttribute('id', @get('id'))
    if @has('name') && @name != "" then xml.setAttribute('name', @get('name'))
    xml
  
  deep_copy: -> SplitRatioProfileSet.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null