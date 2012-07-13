class window.sirius.FeedbackElements extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.FeedbackElements()
    scenarioElement = xml.children('scenarioElement')
    obj.set('scenarioelement', _.map($(scenarioElement), (scenarioElement_i) -> $a.ScenarioElement.from_xml2($(scenarioElement_i), deferred, object_with_id)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('feedbackElements')
    if @encode_references
      @encode_references()
    _.each(@get('scenarioelement') || [], (a_scenarioelement) -> xml.appendChild(a_scenarioelement.to_xml(doc)))
    xml
  
  deep_copy: -> FeedbackElements.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null