aurora_classes_with_extensions = [
  'Begin','Capacity','Controller', 'ControllerSet',
  'Data_sources','Demand', 'Density', 'Display_position',
  'Dynamics', 'End', 'Event', 'EventSet', 'Fd', 'Input',
  'Intersection', 'Link', 'LinkList', 'MonitorList',
  'Network', 'NetworkList', 'Node', 'NodeList', 'Od',
  'ODList', 'Output', 'PathList', 'Phase', 'Plan', 'PlanList',
  'PlanSequence', 'Point', 'Position', 'Qmax', 'Scenario',
  'Sensor', 'SensorList', 'Settings', 'Signal', 'SignalList',
  'Source', 'Splitratios'
]

aurora_classes_without_extensions = [
  'ALatLng', 'ArrayText', 'CapacityProfileSet', 'Components',
  'Control', 'Controlled', 'DemandProfileSet', 'Description',
  'DirectionsCacheEntry', 'DirectionsCache', 'Display', 'EncodedPolyline',
  'From', 'InitialDensityProfile', 'Inputs', 'IntersectionCacheEntry',
  'IntersectionCache', 'Lane_count_change', 'Levels', 'Limits',
  'LinkGeometry', 'LinkPairs', 'Links', 'Lkid', 'Monitored', 'Monitor',
  'Monitors', 'Onramp', 'Onramps', 'Outputs', 'Pair', 'Parameter',
  'Parameters', 'Path', 'Plan_reference', 'Points', 'Postmile',
  'Qcontroller', 'SplitRatioProfileSet', 'Srm', 'Stage', 'Table',
  'To', 'Units', 'VehicleTypes', 'Vtype', 'Weavingfactors', 'Wfm',
  'Zone', 'Zones'
]

load_aurora_classes = (after) ->
  head.js "js/Aurora.js", ->
    class_paths = _.map(aurora_classes_without_extensions, (cname) -> "js/#{cname}.js")
    class_paths.push after
    head.js.apply(@, class_paths)

head.js('../shared/jquery-1.7.1.js',
        '../shared/underscore.js',
        '../shared/backbone.js',
        '../shared/bootstrap/js/bootstrap.js', ->
            load_aurora_classes ->
              try
                window.cap = new window.aurora.Capacity
              catch err
                console.log(err)

              $("#log_cap_xml").click ->
                console.log window.cap.to_xml(document.implementation.createDocument('document:xml'))
)