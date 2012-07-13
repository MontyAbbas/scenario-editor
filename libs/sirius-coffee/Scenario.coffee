class window.sirius.Scenario extends Backbone.Model
  ### $a = alias for sirius namespace ###
  $a = window.sirius
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.sirius.Scenario()
    description = xml.children('description')
    obj.set('description', $a.Description.from_xml2(description, deferred, object_with_id))
    settings = xml.children('settings')
    obj.set('settings', $a.Settings.from_xml2(settings, deferred, object_with_id))
    NetworkList = xml.children('NetworkList')
    obj.set('networklist', $a.NetworkList.from_xml2(NetworkList, deferred, object_with_id))
    SignalList = xml.children('SignalList')
    obj.set('signallist', $a.SignalList.from_xml2(SignalList, deferred, object_with_id))
    SensorList = xml.children('SensorList')
    obj.set('sensorlist', $a.SensorList.from_xml2(SensorList, deferred, object_with_id))
    InitialDensitySet = xml.children('InitialDensitySet')
    obj.set('initialdensityset', $a.InitialDensitySet.from_xml2(InitialDensitySet, deferred, object_with_id))
    WeavingFactorSet = xml.children('WeavingFactorSet')
    obj.set('weavingfactorset', $a.WeavingFactorSet.from_xml2(WeavingFactorSet, deferred, object_with_id))
    SplitRatioProfileSet = xml.children('SplitRatioProfileSet')
    obj.set('splitratioprofileset', $a.SplitRatioProfileSet.from_xml2(SplitRatioProfileSet, deferred, object_with_id))
    DownstreamBoundaryCapacityProfileSet = xml.children('DownstreamBoundaryCapacityProfileSet')
    obj.set('downstreamboundarycapacityprofileset', $a.DownstreamBoundaryCapacityProfileSet.from_xml2(DownstreamBoundaryCapacityProfileSet, deferred, object_with_id))
    EventSet = xml.children('EventSet')
    obj.set('eventset', $a.EventSet.from_xml2(EventSet, deferred, object_with_id))
    DemandProfileSet = xml.children('DemandProfileSet')
    obj.set('demandprofileset', $a.DemandProfileSet.from_xml2(DemandProfileSet, deferred, object_with_id))
    ControllerSet = xml.children('ControllerSet')
    obj.set('controllerset', $a.ControllerSet.from_xml2(ControllerSet, deferred, object_with_id))
    FundamentalDiagramProfileSet = xml.children('FundamentalDiagramProfileSet')
    obj.set('fundamentaldiagramprofileset', $a.FundamentalDiagramProfileSet.from_xml2(FundamentalDiagramProfileSet, deferred, object_with_id))
    NetworkConnections = xml.children('NetworkConnections')
    obj.set('networkconnections', $a.NetworkConnections.from_xml2(NetworkConnections, deferred, object_with_id))
    ODList = xml.children('ODList')
    obj.set('odlist', $a.ODList.from_xml2(ODList, deferred, object_with_id))
    RouteSegments = xml.children('RouteSegments')
    obj.set('routesegments', $a.RouteSegments.from_xml2(RouteSegments, deferred, object_with_id))
    DecisionPoints = xml.children('DecisionPoints')
    obj.set('decisionpoints', $a.DecisionPoints.from_xml2(DecisionPoints, deferred, object_with_id))
    ODDemandProfileSet = xml.children('ODDemandProfileSet')
    obj.set('oddemandprofileset', $a.ODDemandProfileSet.from_xml2(ODDemandProfileSet, deferred, object_with_id))
    id = $(xml).attr('id')
    obj.set('id', id)
    name = $(xml).attr('name')
    obj.set('name', name)
    schemaVersion = $(xml).attr('schemaVersion')
    obj.set('schemaVersion', schemaVersion)
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('scenario')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml(doc)) if @has('description')
    xml.appendChild(@get('settings').to_xml(doc)) if @has('settings')
    xml.appendChild(@get('networklist').to_xml(doc)) if @has('networklist')
    xml.appendChild(@get('signallist').to_xml(doc)) if @has('signallist')
    xml.appendChild(@get('sensorlist').to_xml(doc)) if @has('sensorlist')
    xml.appendChild(@get('initialdensityset').to_xml(doc)) if @has('initialdensityset')
    xml.appendChild(@get('weavingfactorset').to_xml(doc)) if @has('weavingfactorset')
    xml.appendChild(@get('splitratioprofileset').to_xml(doc)) if @has('splitratioprofileset')
    xml.appendChild(@get('downstreamboundarycapacityprofileset').to_xml(doc)) if @has('downstreamboundarycapacityprofileset')
    xml.appendChild(@get('eventset').to_xml(doc)) if @has('eventset')
    xml.appendChild(@get('demandprofileset').to_xml(doc)) if @has('demandprofileset')
    xml.appendChild(@get('controllerset').to_xml(doc)) if @has('controllerset')
    xml.appendChild(@get('fundamentaldiagramprofileset').to_xml(doc)) if @has('fundamentaldiagramprofileset')
    xml.appendChild(@get('networkconnections').to_xml(doc)) if @has('networkconnections')
    xml.appendChild(@get('odlist').to_xml(doc)) if @has('odlist')
    xml.appendChild(@get('routesegments').to_xml(doc)) if @has('routesegments')
    xml.appendChild(@get('decisionpoints').to_xml(doc)) if @has('decisionpoints')
    xml.appendChild(@get('oddemandprofileset').to_xml(doc)) if @has('oddemandprofileset')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('schemaVersion', @get('schemaVersion')) if @has('schemaVersion')
    xml
  
  deep_copy: -> Scenario.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null