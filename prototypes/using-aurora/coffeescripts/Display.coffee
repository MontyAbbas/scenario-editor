class window.aurora.Display extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Display()
    timeMax = $(xml).attr('timeMax')
    obj.set('timeMax', Number(timeMax))
    timeout = $(xml).attr('timeout')
    obj.set('timeout', Number(timeout))
    dt = $(xml).attr('dt')
    obj.set('dt', Number(dt))
    timeInitial = $(xml).attr('timeInitial')
    obj.set('timeInitial', Number(timeInitial))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('display')
    if @encode_references
      @encode_references()
    xml.setAttribute('timeMax', @get('timeMax')) if @has('timeMax')
    if @has('timeout') && @timeout != 50 then xml.setAttribute('timeout', @get('timeout'))
    xml.setAttribute('dt', @get('dt')) if @has('dt')
    if @has('timeInitial') && @timeInitial != 0.0 then xml.setAttribute('timeInitial', @get('timeInitial'))
    xml
  
  deep_copy: -> Display.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null