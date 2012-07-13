class window.sirius.Route_segment extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Route_segment()
    links = xml.children('links')
    obj.set('links', _.map($(links), (links_i) -> $a.Links.from_xml2($(links_i), deferred, object_with_id)))
    id = $(xml).attr('id')
    obj.set('id', id)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('route_segment')
    if @encode_references
      @encode_references()
    _.each(@get('links') || [], (a_links) -> xml.appendChild(a_links.to_xml(doc)))
    xml.setAttribute('id', @get('id')) if @has('id')
    xml
  
  deep_copy: -> Route_segment.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null