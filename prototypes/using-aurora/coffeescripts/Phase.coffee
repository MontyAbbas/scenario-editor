class window.aurora.Phase extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Phase()
    links = xml.find('links')
    obj.set('links', $a.Links.from_xml2(links, deferred, object_with_id))
    nema = $(xml).attr('nema')
    obj.set('nema', Number(nema))
    protected = $(xml).attr('protected')
    obj.set('protected', (protected.toString().toLowerCase() == 'true') if protected?)
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
    xml.appendChild(@get('links').to_xml()) if @has('links')
    xml.setAttribute('nema', @get('nema'))
    xml.setAttribute('protected', @get('protected'))
    xml.setAttribute('permissive', @get('permissive'))
    xml.setAttribute('yellow_time', @get('yellow_time'))
    xml.setAttribute('red_clear_time', @get('red_clear_time'))
    xml.setAttribute('min_green_time', @get('min_green_time'))
    xml.setAttribute('lag', @get('lag'))
    xml.setAttribute('recall', @get('recall'))
    xml
  
  deep_copy: -> Phase.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null