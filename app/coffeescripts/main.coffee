# Originating load file: main.html.
# This set of functions and collections is used to load all the javascript classes and libraries into memory.
# It also registers an onload event with the body class that will instantiate the AppView class and begin
# the rendering process.
sirius_classes_with_extensions = [
  'Begin',
  'Controller', 'ControllerSet',
  'Data_sources', 'Density', 'Display_position', 'Dynamics', 
  'End', 'Event', 'EventSet',
  'Input', 'Intersection', 
  'Link', 'LinkList',
  'Network', 'NetworkList', 'Node', 'NodeList', 
  'Od', 'ODList', 'Output', 
  'Phase', 'Plan', 'PlanList', 'PlanSequence', 'Point', 'Position', 
  'Scenario', 'Sensor', 'SensorList', 'Settings', 'Signal', 'SignalList'
]

sirius_classes_without_extensions = [
  'ALatLng', 'CapacityProfile', 'Data_source', 'Decision_point', 'Decision_point_split',
  'Decision_points', 'DecisionPoints', 'DemandProfile', 'DemandProfileSet', 'Description',
  'DirectionsCacheEntry', 'DirectionsCache', 'DownstreamBoundaryCapacityProfileSet', 'EncodedPolyline',
  'FeedbackElements', 'From', 'FundamentalDiagram', 'FundamentalDiagramProfile', 'FundamentalDiagramProfileSet', 
  'InitialDensitySet', 'Inputs', 'IntersectionCacheEntry',
  'IntersectionCache', 'Knob', 'Lane_count_change', 'Levels', 
  'LinkGeometry', 'Link_reference', 'Linkpair', 'Links', 
  'NetworkConnections', 'Networkpair', 'Od_demandProfile', 'ODDemandProfileSet', 'Outputs', 
  'On_off_switch', 'Outputs', 'Parameter',
  'Parameters', 'Plan_reference', 'Points', 'Postmile',
  'Qcontroller', 'Route_segment', 'Route_segments', 'RouteSegments',
  'ScenarioElement', 'Splitratio',  'SplitratioEvent',  'SplitratioProfile','SplitRatioProfileSet', 'Stage',
  'TargetElements', 'To', 'Units', 'Vehicle_type', 'VehicleTypes', 'VehicleTypeOrder', 'Weavingfactors', 'WeavingfactorSet'
]

sirius_map_view_classes = [
  'MapNetworkModel', 'AppView', 'MapLinkView', 'MapMarkerView', 'MapNetworkView', 'MapNodeView', 'MapSensorView', 'MapControllerView', 'MapEventView', 'MapSignalView', 'Util',
  'TreeView', 'TreeParentItemView', 'TreeChildItemView','NavBarView','NavParentItemView','NavChildItemView', 'FileUploadView'
]

load_sirius_classes = (after) ->
  head.js "js/Sirius.js", ->
    class_paths = _.map(sirius_classes_without_extensions, (cname) -> "js/#{cname}.js")
    class_paths = class_paths.concat _.flatten(_.map(sirius_map_view_classes, (cname) -> "js/#{cname}.js"))
    class_paths = class_paths.concat _.flatten(_.map(
      sirius_classes_with_extensions,
      (cname) -> ["js/#{cname}.js","js/extensions/#{cname}.js"]
    ))
    class_paths.push after
    head.js.apply(@, class_paths)

# we wait to load ContextMenu.js until after the google libs load
window.load_context_menu_and_app_view = ->
    head.js 'js/LayersHandlerItem.js',
            'js/LayersHandler.js',
            'js/menu-data.js',
            '../libs/js/ContextMenu.js', ->
              # static instance level event aggegator that most classes use to register their
              # own listeners on
              window.sirius.broker = _.clone(Backbone.Events)
              new window.sirius.AppView()
              lmenu = new window.LayersHandler({})
              lmenu.createHTML()
              lmenu.attachEvents()

head.js('https://www.google.com/jsapi',
        '../libs/js/jquery-1.7.1.js',
        '../libs/js/jquery-ui-1.8.18.min.js',
        '../libs/js/underscore.js',
        '../libs/js/backbone.js',
        '../libs/js/bootstrap/js/bootstrap.js', ->
            load_sirius_classes ->
               google.load("maps", "3", {
                  callback: "window.load_context_menu_and_app_view()",
                  other_params: "libraries=geometry,drawing&sensor=false"
                 });
)