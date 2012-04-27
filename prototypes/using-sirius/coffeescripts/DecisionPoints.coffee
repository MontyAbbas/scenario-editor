class window.sirius.DecisionPoints extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.DecisionPoints()
    decision_point = xml.children('decision_point')
    obj.set('decision_point', _.map($(decision_point), (decision_point_i) -> $a.Decision_point.from_xml2($(decision_point_i), deferred, object_with_id)))
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('DecisionPoints')
    if @encode_references
      @encode_references()
    _.each(@get('decision_point') || [], (a_decision_point) -> xml.appendChild(a_decision_point.to_xml(doc)))
    xml
  
  deep_copy: -> DecisionPoints.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null