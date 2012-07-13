class window.sirius.FundamentalDiagramProfileSet extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.FundamentalDiagramProfileSet()
    description = xml.children('description')
    obj.set('description', $a.Description.from_xml2(description, deferred, object_with_id))
    fundamentalDiagramProfile = xml.children('fundamentalDiagramProfile')
    obj.set('fundamentaldiagramprofile', _.map($(fundamentalDiagramProfile), (fundamentalDiagramProfile_i) -> $a.FundamentalDiagramProfile.from_xml2($(fundamentalDiagramProfile_i), deferred, object_with_id)))
    id = $(xml).attr('id')
    obj.set('id', id)
    name = $(xml).attr('name')
    obj.set('name', name)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('FundamentalDiagramProfileSet')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml(doc)) if @has('description')
    _.each(@get('fundamentaldiagramprofile') || [], (a_fundamentaldiagramprofile) -> xml.appendChild(a_fundamentaldiagramprofile.to_xml(doc)))
    if @has('id') && @id != "" then xml.setAttribute('id', @get('id'))
    if @has('name') && @name != "" then xml.setAttribute('name', @get('name'))
    xml
  
  deep_copy: -> FundamentalDiagramProfileSet.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null