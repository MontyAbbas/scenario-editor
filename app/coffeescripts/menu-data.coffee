# The names of all the parent tree elements of the scenario. It is used in MapNetworkView's _treeView method
window.main_tree_elements = [
  'Initial Density Profiles', 'Network List', 'Controllers', 'Demand Profiles', 'Events', 'Fundamental Diagram Profiles', 'OD Demand Profiles',
  'Network Connections','Downstream Boundary Profiles','Split Ratio Profiles','Sensors','Signals'
  ]



window.nav_bar_menu_items = {
    'File': ['New','Open Local Network', 'Close Local Network', 'Import Local Network']
    'Windows': ['Node Browser', 'Link Browser', 'Path Browser', 'Event Browser', 'Controller Browser', 'Sensor Browser', 'Network Properties']
    'Tools': ['Import PeMS data', 'Calibrate', 'Simulate']
    'Help': ['About', 'Help', 'Version', 'Identity', 'Contact', 'Legal']
  }

window.nav_bar_menu_items_events = {
  'Open Local Network' : 'window.upload'
  
}

window.upload = (e) -> 
  $("#uploadField").click()
  e.preventDefault()