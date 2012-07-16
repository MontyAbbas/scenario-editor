$a = window.sirius
# The names of all the parent tree elements of the scenario. It is used in MapNetworkView's _treeView method
$a.main_tree_elements = [
  'Initial Density Profiles', 'Network List', 'Controllers', 'Demand Profiles', 'Events', 'Fundamental Diagram Profiles', 'OD Demand Profiles',
  'Network Connections','Downstream Boundary Profiles','Split Ratio Profiles','Sensors','Signals'
  ]


# The menu items and their events for the main navigation bar
$a.nav_bar_menu_items = {
    'File': {
              'New' : (() -> alert('Not Configured'))
              'Open Local Network' : ((e) ->
                                        $a.broker.trigger('app:clear_map')
                                        $("#uploadField").click()
                                        e.preventDefault())
              'Close Local Network' : (() -> $a.broker.trigger('app:clear_map'))
              'Import Local Network' : (() -> alert('Not Configured'))
            }
    'Windows': {
                'Node Browser' : (() -> alert('Not Configured'))
                'Link Browser' : (() -> alert('Not Configured'))
                'Path Browser' : (() -> alert('Not Configured'))
                'Event Browser' : (() -> alert('Not Configured'))
                'Controller Browser' : (() -> alert('Not Configured'))
                'Sensor Browser' : (() -> alert('Not Configured'))
                'Network Properties' : (() -> alert('Not Configured'))
              }
    'Tools': {
              'Import PeMS data' : (() -> alert('Not Configured'))
              'Calibrate' : (() -> alert('Not Configured'))
              'Simulate' : (() -> alert('Not Configured'))
            }
    'Help': {
              'About' : (() -> alert('Not Configured'))
              'Help' : (() -> alert('Not Configured'))
              'Version' : (() -> alert('Not Configured'))
              'Identity' : (() -> alert('Not Configured'))
              'Contact' : (() -> alert('Not Configured'))
              'Legal' : (() -> alert('Not Configured'))
            }
}

# Main window context menu
$a.main_context_menu = [
   {className:'context_menu_item', event: (() -> $a.map.setZoom $a.map.getZoom()+1), label:'Zoom in'}
   {className:'context_menu_item', event: (() -> $a.map.setZoom $a.map.getZoom()-1), label:'Zoom out'}
   {className:'context_menu_separator'}
   {className:'context_menu_item', event: (() -> $a.map.panTo $a.contextMenu.position), label:'Center map here'}
]

# Link Context Menu
$a.link_context_menu = [
  { label: 'Select Link and its Nodes', className: 'context_menu_item', event: ((e) -> $a.broker.trigger("map:select_neighbors:#{e.currentTarget.id}")) }
  { label: 'Clear Selection', className: 'context_menu_item', event: ((e) -> $a.broker.trigger("map:clear_neighbors:#{e.currentTarget.id}")) }
]

# Sensor Context Menu
$a.sensor_context_menu = [
  { label: 'Select sensor link', className: 'context_menu_item', event: ((e) -> $a.broker.trigger("map:select_neighbors:#{e.currentTarget.id}")) }
  { label: 'Clear Selection', className: 'context_menu_item', event: ((e) -> $a.broker.trigger("map:clear_neighbors:#{e.currentTarget.id}")) }
]

# Node Context Menu
$a.node_context_menu = [
  { label: 'Select node and its links', className: 'context_menu_item', event: ((e) -> $a.broker.trigger("map:select_neighbors:#{e.currentTarget.id}")) }
  { label: 'Select Outgoing links', className: 'context_menu_item', event: ((e) -> $a.broker.trigger("map:select_neighbors_outgoing:#{e.currentTarget.id}",['output'])) }
  { label: 'Select Incoming links', className: 'context_menu_item', event: ((e) -> $a.broker.trigger("map:select_neighbors_incoming:#{e.currentTarget.id}",['input'])) }
  { label: 'Clear Selection', className: 'context_menu_item', event: ((e) -> $a.broker.trigger("map:clear_neighbors:#{e.currentTarget.id}")) }
]

# Layers Menu
$a.layers_node_type_list = [
       { label: 'Freeway Nodes', event: 'toggleVisabilty', triggerShow: "map:nodes:show_freeway", triggerHide: "map:nodes:hide_freeway" }
       { label: 'Highway Nodes',  event: ((e) -> alert('Not Configured'))  }
       { label: 'Signalized Intersections', event: 'toggleVisabilty', triggerShow: "map:nodes:show_signalized_intersection", triggerHide: "map:nodes:hide_signalized_intersection"  }
       { label: 'Stop Intersections',  event: ((e) -> alert('Not Configured')) }
       { label: 'Terminals', event: 'toggleVisabilty', triggerShow: "map:nodes:show_terminal", triggerHide: "map:nodes:hide_terminal"  }
       { label: 'Other', event: 'toggleVisabilty', triggerShow: "map:nodes:show_simple", triggerHide: "map:nodes:hide_simple"  }  
     ]

$a.layers_link_type_list = [
      { label: 'Freeway mainlines', event: 'toggleVisabilty', triggerShow: "map:links:show_freeway", triggerHide: "map:links:hide_freeway"  }
      { label: 'Highway mainlines', event: 'toggleVisabilty', triggerShow: "map:links:show_highway", triggerHide: "map:links:hide_highway"  }
      { label: 'HOV lanes', event: 'toggleVisabilty', triggerShow: "map:links:show_hov", triggerHide: "map:links:hide_hov"  }
      { label: 'HOT lanes', event: 'toggleVisabilty', triggerShow: "map:links:show_hot", triggerHide: "map:links:hide_hot"  }
      { label: 'Heavy vehicle lanes', event: ((e) -> alert('Not Configured'))  }
      { label: 'Elec. toll coll. lanes',  event: ((e) -> alert('Not Configured'))   }
      { label: 'On-ramps', event: 'toggleVisabilty', triggerShow: "map:links:show_onramp", triggerHide: "map:links:hide_onramp"  }
      { label: 'Off-ramps', event: 'toggleVisabilty', triggerShow: "map:links:show_offramp", triggerHide: "map:links:hide_offramp"  }
      { label: 'Interconnects', event: 'toggleVisabilty', triggerShow: "map:links:show_freeway_connector", triggerHide: "map:links:hide_freeway_connector" }
      { label: 'Streets', event: 'toggleVisabilty', triggerShow: "map:links:show_street", triggerHide: "map:links:hide_street"  }
      { label: 'Dummy links', event: ((e) -> alert('Not Configured')) }
    ]

$a.layers_menu = [
  { label: 'Show all nodes', event: ((e) -> $a.broker.trigger('map:show_node_layer')) }
  { label: 'Hide all nodes', event: ((e) -> $a.broker.trigger('map:hide_node_layer')) }
  { label: 'Nodes', className: 'dropdown submenu', link: 'nodeTypeList', href: '#nodeTypeList', items: $a.layers_node_type_list }
  { className: 'divider' }
  { label: 'Show all links', event: ((e) -> $a.broker.trigger('map:show_link_layer')) }
  { label: 'Hide all links', event: ((e) -> $a.broker.trigger('map:hide_link_layer')) }
  { label: 'Links', className: 'dropdown submenu', href: '#linkTypeList', link: 'linkTypeList', items: $a.layers_link_type_list }
  { className: 'divider' }
  { label: 'Events', event: 'toggleVisabilty', triggerShow: "map:show_event_layer", triggerHide: "map:hide_event_layer" }
  { label: 'Controllers',  event: 'toggleVisabilty', triggerShow: "map:show_controller_layer", triggerHide: "map:hide_controller_layer" }
  { label: 'Sensors', event: 'toggleVisabilty', triggerShow: "map:show_sensor_layer", triggerHide: "map:hide_sensor_layer" }
]

