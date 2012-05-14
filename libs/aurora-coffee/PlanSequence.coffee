class window.aurora.PlanSequence extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.PlanSequence()
    plan_reference = xml.children('plan_reference')
    obj.set('plan_reference', _.map($(plan_reference), (plan_reference_i) -> $a.Plan_reference.from_xml2($(plan_reference_i), deferred, object_with_id)))
    transition_delay = $(xml).attr('transition_delay')
    obj.set('transition_delay', Number(transition_delay))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('PlanSequence')
    if @encode_references
      @encode_references()
    _.each(@get('plan_reference') || [], (a_plan_reference) -> xml.appendChild(a_plan_reference.to_xml(doc)))
    xml.setAttribute('transition_delay', @get('transition_delay')) if @has('transition_delay')
    xml
  
  deep_copy: -> PlanSequence.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null