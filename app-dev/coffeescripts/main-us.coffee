sirius_classes_with_extensions = [
  'Begin','Controller', 'ControllerSet',
  'Data_sources', 'Density', 'Display_position',
  'Dynamics', 'End', 'Event', 'EventSet', 'Input',
  'Intersection', 'Link', 'LinkList',
  'Network', 'NetworkList', 'Node', 'NodeList', 'Od',
  'ODList', 'Output', 'Phase', 'Plan', 'PlanList',
  'PlanSequence', 'Point', 'Position', 'Scenario',
  'Sensor', 'SensorList', 'Settings', 'Signal', 'SignalList',
  'TargetElements'
]

sirius_classes_without_extensions = [
  'ALatLng', 'ArrayText', 'CapacityProfile',
  'Data_source', 'Decision_point', 'Decision_points', 'DecisionPoints',
  'Decision_point_split', 'DemandProfile', 'DemandProfileSet', 'Description',
  'DirectionsCache', 'DirectionsCacheEntry', 'DirectionsCache',
  'DownstreamBoundaryCapacitySet', 'EncodedPolyline', 'FeedbackElements',
  'From', 'FundamentalDiagram', 'FundamentalDiagramProfile', 'FundamentalDiagramProfileSet',
  'InitialDensityProfile', 'Inputs', 'IntersectionCacheEntry',
  'IntersectionCache', 'Knob', 'Lane_count_change', 'Levels',
  'LinkGeometry', 'Linkpair', 'Links', 'Link_reference',
  'NetworkConnections', 'Networkpair', 'ODDemandPofileSet', 'Od_demandProfile',
  'ODList', 'On_off_switch', 'Outputs', 'Parameter',
  'Parameters', 'PathSegements', 'Path_segment', 'Path_segments', 'Plan_reference', 'PlanSequence',
  'Points', 'Postmile','Qcontroller', 'ScenarioElement', 'Splitratio',
  'SplitratioEvent', 'SplitratioProfile',
  'SplitRatioProfileSet', 'Stage', 'TargetElements',
  'To', 'Units', 'VehicleType', 'VehicleTypeOrder', 'VehicleTypes', 'Weavingfactors', 'WeavingFactorsProfile'
]

load_sirius_classes = (after) ->
  head.js "js/Sirius.js", ->
    class_paths = _.map(sirius_classes_without_extensions, (cname) -> "js/#{cname}.js")
    class_paths = class_paths.concat _.flatten(_.map(
      sirius_classes_with_extensions,
      (cname) -> ["js/#{cname}.js","js/extensions/#{cname}.js"]
    ))
    class_paths.push after
    head.js.apply(@, class_paths)

head.js('../shared/jquery-1.7.1.js',
        '../shared/underscore.js',
        '../shared/backbone.js',
        '../shared/bootstrap/js/bootstrap.js', ->
            load_sirius_classes ->
              $("#load_scenario").click ->
                xml_text = $("#scenario_text").val()
                xml = $.parseXML(xml_text)
                window.textarea_scenario = window.sirius.Scenario.from_xml($(xml).children())
              $("#write_scenario_as_xml").click ->
                doc = document.implementation.createDocument('document:xml','scenario',null)
                the_xml = window.textarea_scenario.to_xml(doc)
                console.log(the_xml)
)