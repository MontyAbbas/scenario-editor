class window.sirius.Od_demandProfile extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Od_demandProfile()
    knob = $(xml).attr('knob')
    obj.set('knob', Number(knob))
    start_time = $(xml).attr('start_time')
    obj.set('start_time', Number(start_time))
    dt = $(xml).attr('dt')
    obj.set('dt', Number(dt))
    od_id = $(xml).attr('od_id')
    obj.set('od_id', od_id)
    std_dev_add = $(xml).attr('std_dev_add')
    obj.set('std_dev_add', Number(std_dev_add))
    std_dev_mult = $(xml).attr('std_dev_mult')
    obj.set('std_dev_mult', Number(std_dev_mult))
    obj.set('text', xml.text())
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('od_demandProfile')
    if @encode_references
      @encode_references()
    xml.setAttribute('knob', @get('knob')) if @has('knob')
    if @has('start_time') && @start_time != 0 then xml.setAttribute('start_time', @get('start_time'))
    xml.setAttribute('dt', @get('dt')) if @has('dt')
    xml.setAttribute('od_id', @get('od_id')) if @has('od_id')
    xml.setAttribute('std_dev_add', @get('std_dev_add')) if @has('std_dev_add')
    xml.setAttribute('std_dev_mult', @get('std_dev_mult')) if @has('std_dev_mult')
    xml.appendChild(doc.createTextNode($a.ArrayText.emit(@get('text') || [])))
    xml
  
  deep_copy: -> Od_demandProfile.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null