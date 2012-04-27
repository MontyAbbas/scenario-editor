class window.sirius.Phase extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Phase()
    links = xml.children('links')
    obj.set('links', $a.Links.from_xml2(links, deferred, object_with_id))
    nema = $(xml).attr('nema')
    obj.set('nema', Number(nema))
    protected_ = $(xml).attr('protected_')
    obj.set('protected_', (protected_.toString().toLowerCase() == 'true') if protected_?)
    permissive = $(xml).attr('permissive')
    obj.set('permissive', (permissive.toString().toLowerCase() == 'true') if permissive?)
    yellow_time = $(xml).attr('yellow_time')
    obj.set('yellow_time', Number(yellow_time))
    red_clear_time = $(xml).attr('red_clear_time')
    obj.set('red_clear_time', Number(red_clear_time))
    min_green_time = $(xml).attr('min_green_time')
    obj.set('min_green_time', Number(min_green_time))
    lag = $(xml).attr('lag')
    obj.set('lag', (lag.toString().toLowerCase() == 'true') if lag?)
    recall = $(xml).attr('recall')
    obj.set('recall', (recall.toString().toLowerCase() == 'true') if recall?)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('phase')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('links').to_xml(doc)) if @has('links')
    xml.setAttribute('nema', @get('nema')) if @has('nema')
    xml.setAttribute('protected_', @get('protected_')) if @has('protected_')
    xml.setAttribute('permissive', @get('permissive')) if @has('permissive')
    xml.setAttribute('yellow_time', @get('yellow_time')) if @has('yellow_time')
    xml.setAttribute('red_clear_time', @get('red_clear_time')) if @has('red_clear_time')
    xml.setAttribute('min_green_time', @get('min_green_time')) if @has('min_green_time')
    xml.setAttribute('lag', @get('lag')) if @has('lag')
    xml.setAttribute('recall', @get('recall')) if @has('recall')
    xml
  
  deep_copy: -> Phase.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null