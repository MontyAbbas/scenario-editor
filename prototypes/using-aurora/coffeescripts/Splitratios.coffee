class window.aurora.Splitratios extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Splitratios()
    srm = xml.find('srm')
    obj.set 'srm', _.map(srm, (srm_i) -> $a.Srm.from_xml2(srm_i, deferred, object_with_id))
    node_id = xml.find('node_id')
    obj.set 'node_id', xml.node_id
    start_time = xml.find('start_time')
    obj.set 'start_time', Number(start_time)
    dt = xml.find('dt')
    obj.set 'dt', Number(dt)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('splitratios')
    if @encode_references
      @encode_references()
    _.each(@get('srm') || [], (a_srm) -> xml.appendChild(a_srm.to_xml()))
    xml.setAttribute('node_id', @get('node_id'))
    if @has('start_time') && @start_time != 0 then xml.setAttribute('start_time', @get('start_time'))
    xml.setAttribute('dt', @get('dt'))
    xml
  
  deep_copy: -> Splitratios.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null