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
    InitialDensityProfile = xml.children('InitialDensityProfile')
    obj.set('initialdensityprofile', $a.InitialDensityProfile.from_xml2(InitialDensityProfile, deferred, object_with_id))
    WeavingFactorsProfile = xml.children('WeavingFactorsProfile')
    obj.set('weavingfactorsprofile', $a.WeavingFactorsProfile.from_xml2(WeavingFactorsProfile, deferred, object_with_id))
    SplitRatioProfileSet = xml.children('SplitRatioProfileSet')
    obj.set('splitratioprofileset', $a.SplitRatioProfileSet.from_xml2(SplitRatioProfileSet, deferred, object_with_id))
    DownstreamBoundaryCapacitySet = xml.children('DownstreamBoundaryCapacitySet')
    obj.set('downstreamboundarycapacityset', $a.DownstreamBoundaryCapacitySet.from_xml2(DownstreamBoundaryCapacitySet, deferred, object_with_id))
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
    PathSegements = xml.children('PathSegements')
    obj.set('pathsegements', $a.PathSegements.from_xml2(PathSegements, deferred, object_with_id))
    DecisionPoints = xml.children('DecisionPoints')
    obj.set('decisionpoints', $a.DecisionPoints.from_xml2(DecisionPoints, deferred, object_with_id))
    ODDemandPofileSet = xml.children('ODDemandPofileSet')
    obj.set('oddemandpofileset', $a.ODDemandPofileSet.from_xml2(ODDemandPofileSet, deferred, object_with_id))
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
    xml.appendChild(@get('initialdensityprofile').to_xml(doc)) if @has('initialdensityprofile')
    xml.appendChild(@get('weavingfactorsprofile').to_xml(doc)) if @has('weavingfactorsprofile')
    xml.appendChild(@get('splitratioprofileset').to_xml(doc)) if @has('splitratioprofileset')
    xml.appendChild(@get('downstreamboundarycapacityset').to_xml(doc)) if @has('downstreamboundarycapacityset')
    xml.appendChild(@get('eventset').to_xml(doc)) if @has('eventset')
    xml.appendChild(@get('demandprofileset').to_xml(doc)) if @has('demandprofileset')
    xml.appendChild(@get('controllerset').to_xml(doc)) if @has('controllerset')
    xml.appendChild(@get('fundamentaldiagramprofileset').to_xml(doc)) if @has('fundamentaldiagramprofileset')
    xml.appendChild(@get('networkconnections').to_xml(doc)) if @has('networkconnections')
    xml.appendChild(@get('odlist').to_xml(doc)) if @has('odlist')
    xml.appendChild(@get('pathsegements').to_xml(doc)) if @has('pathsegements')
    xml.appendChild(@get('decisionpoints').to_xml(doc)) if @has('decisionpoints')
    xml.appendChild(@get('oddemandpofileset').to_xml(doc)) if @has('oddemandpofileset')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('schemaVersion', @get('schemaVersion')) if @has('schemaVersion')
    xml
  
  deep_copy: -> Scenario.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null