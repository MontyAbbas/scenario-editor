class window.aurora.Scenario extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if (not xml? or xml.length == 0)
    obj = new window.aurora.Scenario()
    description = xml.children('description')
    obj.set('description', $a.Description.from_xml2(description, deferred, object_with_id))
    network = xml.children('network')
    obj.set('network', $a.Network.from_xml2(network, deferred, object_with_id))
    settings = xml.children('settings')
    obj.set('settings', $a.Settings.from_xml2(settings, deferred, object_with_id))
    InitialDensityProfile = xml.children('InitialDensityProfile')
    obj.set('initialdensityprofile', $a.InitialDensityProfile.from_xml2(InitialDensityProfile, deferred, object_with_id))
    SplitRatioProfileSet = xml.children('SplitRatioProfileSet')
    obj.set('splitratioprofileset', $a.SplitRatioProfileSet.from_xml2(SplitRatioProfileSet, deferred, object_with_id))
    CapacityProfileSet = xml.children('CapacityProfileSet')
    obj.set('capacityprofileset', $a.CapacityProfileSet.from_xml2(CapacityProfileSet, deferred, object_with_id))
    EventSet = xml.children('EventSet')
    obj.set('eventset', $a.EventSet.from_xml2(EventSet, deferred, object_with_id))
    DemandProfileSet = xml.children('DemandProfileSet')
    obj.set('demandprofileset', $a.DemandProfileSet.from_xml2(DemandProfileSet, deferred, object_with_id))
    ControllerSet = xml.children('ControllerSet')
    obj.set('controllerset', $a.ControllerSet.from_xml2(ControllerSet, deferred, object_with_id))
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
    xml.appendChild(@get('network').to_xml(doc)) if @has('network')
    xml.appendChild(@get('settings').to_xml(doc)) if @has('settings')
    xml.appendChild(@get('initialdensityprofile').to_xml(doc)) if @has('initialdensityprofile')
    xml.appendChild(@get('splitratioprofileset').to_xml(doc)) if @has('splitratioprofileset')
    xml.appendChild(@get('capacityprofileset').to_xml(doc)) if @has('capacityprofileset')
    xml.appendChild(@get('eventset').to_xml(doc)) if @has('eventset')
    xml.appendChild(@get('demandprofileset').to_xml(doc)) if @has('demandprofileset')
    xml.appendChild(@get('controllerset').to_xml(doc)) if @has('controllerset')
    xml.setAttribute('id', @get('id')) if @has('id')
    xml.setAttribute('name', @get('name')) if @has('name')
    xml.setAttribute('schemaVersion', @get('schemaVersion')) if @has('schemaVersion')
    xml
  
  deep_copy: -> Scenario.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null