class window.sirius.Data_sources extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Data_sources()
    data_source = xml.children('data_source')
    obj.set('data_source', _.map($(data_source), (data_source_i) -> $a.Data_source.from_xml2($(data_source_i), deferred, object_with_id)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('data_sources')
    if @encode_references
      @encode_references()
    _.each(@get('data_source') || [], (a_data_source) -> xml.appendChild(a_data_source.to_xml(doc)))
    xml
  
  deep_copy: -> Data_sources.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null