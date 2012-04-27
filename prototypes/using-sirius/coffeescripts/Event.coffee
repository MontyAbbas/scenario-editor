class window.sirius.Event extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Event()
    description = xml.children('description')
    obj.set('description', $a.Description.from_xml2(description, deferred, object_with_id))
    display_position = xml.children('display_position')
    obj.set('display_position', $a.Display_position.from_xml2(display_position, deferred, object_with_id))
    targetElements = xml.children('targetElements')
    obj.set('targetelements', $a.TargetElements.from_xml2(targetElements, deferred, object_with_id))
    fundamentalDiagram = xml.children('fundamentalDiagram')
    obj.set('fundamentaldiagram', $a.FundamentalDiagram.from_xml2(fundamentalDiagram, deferred, object_with_id))
    lane_count_change = xml.children('lane_count_change')
    obj.set('lane_count_change', $a.Lane_count_change.from_xml2(lane_count_change, deferred, object_with_id))
    on_off_switch = xml.children('on_off_switch')
    obj.set('on_off_switch', $a.On_off_switch.from_xml2(on_off_switch, deferred, object_with_id))
    knob = xml.children('knob')
    obj.set('knob', $a.Knob.from_xml2(knob, deferred, object_with_id))
    splitratioEvent = xml.children('splitratioEvent')
    obj.set('splitratioevent', $a.SplitratioEvent.from_xml2(splitratioEvent, deferred, object_with_id))
    id = $(xml).attr('id')
    obj.set('id', id)
    reset_to_nominal = $(xml).attr('reset_to_nominal')
    obj.set('reset_to_nominal', (reset_to_nominal.toString().toLowerCase() == 'true') if reset_to_nominal?)
    tstamp = $(xml).attr('tstamp')
    obj.set('tstamp', Number(tstamp))
    enabled = $(xml).attr('enabled')
    obj.set('enabled', (enabled.toString().toLowerCase() == 'true') if enabled?)
    type = $(xml).attr('type')
    obj.set('type', type)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('event')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml(doc)) if @has('description')
    xml.appendChild(@get('display_position').to_xml(doc)) if @has('display_position')
    xml.appendChild(@get('targetelements').to_xml(doc)) if @has('targetelements')
    xml.appendChild(@get('fundamentaldiagram').to_xml(doc)) if @has('fundamentaldiagram')
    xml.appendChild(@get('lane_count_change').to_xml(doc)) if @has('lane_count_change')
    xml.appendChild(@get('on_off_switch').to_xml(doc)) if @has('on_off_switch')
    xml.appendChild(@get('knob').to_xml(doc)) if @has('knob')
    xml.appendChild(@get('splitratioevent').to_xml(doc)) if @has('splitratioevent')
    xml.setAttribute('id', @get('id')) if @has('id')
    if @has('reset_to_nominal') && @reset_to_nominal != false then xml.setAttribute('reset_to_nominal', @get('reset_to_nominal'))
    xml.setAttribute('tstamp', @get('tstamp')) if @has('tstamp')
    xml.setAttribute('enabled', @get('enabled')) if @has('enabled')
    xml.setAttribute('type', @get('type')) if @has('type')
    xml
  
  deep_copy: -> Event.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null