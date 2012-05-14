class window.sirius.SplitratioProfile extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.SplitratioProfile()
    splitratio = xml.children('splitratio')
    obj.set('splitratio', _.map($(splitratio), (splitratio_i) -> $a.Splitratio.from_xml2($(splitratio_i), deferred, object_with_id)))
    network_id = $(xml).attr('network_id')
    obj.set('network_id', network_id)
    node_id = $(xml).attr('node_id')
    obj.set('node_id', node_id)
    start_time = $(xml).attr('start_time')
    obj.set('start_time', Number(start_time))
    dt = $(xml).attr('dt')
    obj.set('dt', Number(dt))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('splitratioProfile')
    if @encode_references
      @encode_references()
    _.each(@get('splitratio') || [], (a_splitratio) -> xml.appendChild(a_splitratio.to_xml(doc)))
    xml.setAttribute('network_id', @get('network_id')) if @has('network_id')
    xml.setAttribute('node_id', @get('node_id')) if @has('node_id')
    if @has('start_time') && @start_time != 0 then xml.setAttribute('start_time', @get('start_time'))
    xml.setAttribute('dt', @get('dt')) if @has('dt')
    xml
  
  deep_copy: -> SplitratioProfile.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null