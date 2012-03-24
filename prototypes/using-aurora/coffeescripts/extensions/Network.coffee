window.aurora.Network::defaults =
  ml_control: false
  q_control: false
  dt: 300

window.aurora.Network::initialize = ->
  @set 'nodelist', new window.aurora.NodeList
  @set 'linklist', new window.aurora.LinkList
  @set 'networklist', new window.aurora.NetworkList
  @set 'odlist', new window.aurora.ODList
  @set 'sensorlist', new window.aurora.SensorList
  @set 'signallist', new window.aurora.SignalList
  @set 'monitorlist', new window.aurora.MonitorList
  @set 'description', new window.aurora.Description
  @set 'position', new window.aurora.Position
  @get('position').get('point').push(new window.aurora.Point)

window.aurora.Network::description_text = ->
  @get('description').get('text')

window.aurora.Network::set_description_text = (s) ->
  @get('description').set('text',s)