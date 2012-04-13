class window.aurora.Splitratios extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Splitratios()
    srm = xml.children('srm')
    obj.set('srm', _.map($(srm), (srm_i) -> $a.Srm.from_xml2($(srm_i), deferred, object_with_id)))
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
    xml = doc.createElement('splitratios')
    if @encode_references
      @encode_references()
    _.each(@get('srm') || [], (a_srm) -> xml.appendChild(a_srm.to_xml(doc)))
    xml.setAttribute('node_id', @get('node_id')) if @has('node_id')
    if @has('start_time') && @start_time != 0 then xml.setAttribute('start_time', @get('start_time'))
    xml.setAttribute('dt', @get('dt')) if @has('dt')
    xml
  
  deep_copy: -> Splitratios.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null