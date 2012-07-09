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
                                        window.triggerEvent('clearMap') 
                                        $("#uploadField").click()
                                        e.preventDefault())
              'Close Local Network' : (() -> window.triggerEvent('clearMap'))
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

###### Main window context menu
$a.main_context_menu = [
   {className:'context_menu_item', event: (() -> $a.map.setZoom $a.map.getZoom()+1), label:'Zoom in'}
   {className:'context_menu_item', event: (() -> $a.map.setZoom $a.map.getZoom()-1), label:'Zoom out'}
   {className:'context_menu_separator'}
   {className:'context_menu_item', event: (() -> $a.map.panTo $a.contextMenu.position), label:'Center map here'}
]

###### Link Context Menu
$a.link_context_menu = [
  { label: 'Select Link and its Nodes', className: 'context_menu_item', event: (() -> alert('Not Configured')) }
  { label: 'Clear Selection', className: 'context_menu_item', event: (() -> alert('Not Configured')) }
]