class window.sirius.FundamentalDiagramProfile extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.FundamentalDiagramProfile()
    fundamentalDiagram = xml.children('fundamentalDiagram')
    obj.set('fundamentaldiagram', _.map($(fundamentalDiagram), (fundamentalDiagram_i) -> $a.FundamentalDiagram.from_xml2($(fundamentalDiagram_i), deferred, object_with_id)))
    network_id = $(xml).attr('network_id')
    obj.set('network_id', network_id)
    link_id = $(xml).attr('link_id')
    obj.set('link_id', link_id)
    start_time = $(xml).attr('start_time')
    obj.set('start_time', Number(start_time))
    dt = $(xml).attr('dt')
    obj.set('dt', Number(dt))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('fundamentalDiagramProfile')
    if @encode_references
      @encode_references()
    _.each(@get('fundamentaldiagram') || [], (a_fundamentaldiagram) -> xml.appendChild(a_fundamentaldiagram.to_xml(doc)))
    xml.setAttribute('network_id', @get('network_id')) if @has('network_id')
    xml.setAttribute('link_id', @get('link_id')) if @has('link_id')
    if @has('start_time') && @start_time != 0 then xml.setAttribute('start_time', @get('start_time'))
    xml.setAttribute('dt', @get('dt')) if @has('dt')
    xml
  
  deep_copy: -> FundamentalDiagramProfile.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null