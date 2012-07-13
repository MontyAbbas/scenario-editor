class window.sirius.Controller extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Controller()
    display_position = xml.children('display_position')
    obj.set('display_position', $a.Display_position.from_xml2(display_position, deferred, object_with_id))
    targetElements = xml.children('targetElements')
    obj.set('targetelements', $a.TargetElements.from_xml2(targetElements, deferred, object_with_id))
    feedbackElements = xml.children('feedbackElements')
    obj.set('feedbackelements', $a.FeedbackElements.from_xml2(feedbackElements, deferred, object_with_id))
    parameters = xml.children('parameters')
    obj.set('parameters', _.reduce(parameters.find("parameter"),
          (acc,par_xml) ->
            wrapped_xml = $(par_xml);
            acc[wrapped_xml.attr('name')] = wrapped_xml.attr('value')
            acc
          {}
    ))
    qcontroller = xml.children('qcontroller')
    obj.set('qcontroller', $a.Qcontroller.from_xml2(qcontroller, deferred, object_with_id))
    PlanSequence = xml.children('PlanSequence')
    obj.set('plansequence', $a.PlanSequence.from_xml2(PlanSequence, deferred, object_with_id))
    PlanList = xml.children('PlanList')
    obj.set('planlist', $a.PlanList.from_xml2(PlanList, deferred, object_with_id))
    name = $(xml).attr('name')
    obj.set('name', name)
    link_position = $(xml).attr('link_position')
    obj.set('link_position', Number(link_position))
    type = $(xml).attr('type')
    obj.set('type', type)
    id = $(xml).attr('id')
    obj.set('id', id)
    dt = $(xml).attr('dt')
    obj.set('dt', Number(dt))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('controller')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('display_position').to_xml(doc)) if @has('display_position')
    xml.appendChild(@get('targetelements').to_xml(doc)) if @has('targetelements')
    xml.appendChild(@get('feedbackelements').to_xml(doc)) if @has('feedbackelements')
    if @has('parameters')
      parameters_xml = doc.createElement('parameters')
      _.each(@get('parameters'), (par_val, par_name) ->
          parameter_xml = doc.createElement('parameter')
          parameter_xml.setAttribute(par_name, par_val)
          parameters_xml.appendChild(parameter_xml)
      )
      xml.appendChild(parameters_xml)
    
    xml.appendChild(@get('qcontroller').to_xml(doc)) if @has('qcontroller')
    xml.appendChild(@get('plansequence').to_xml(doc)) if @has('plansequence')
    xml.appendChild(@get('planlist').to_xml(doc)) if @has('planlist')
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('link_position', @get('link_position')) if @has('link_position')
    xml.setAttribute('type', @get('type')) if @has('type')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('dt', @get('dt')) if @has('dt')
    xml
  
  deep_copy: -> Controller.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null