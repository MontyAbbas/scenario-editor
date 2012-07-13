window.sirius.Network::defaults =
  ml_control: false
  q_control: false
  dt: 300

window.sirius.Network::initialize = ->
  @set 'nodelist', new window.sirius.NodeList
  @set 'linklist', new window.sirius.LinkList
  @set 'networklist', new window.sirius.NetworkList
  @set 'odlist', new window.sirius.ODList
  @set 'sensorlist', new window.sirius.SensorList
  @set 'signallist', new window.sirius.SignalList
  @set 'description', new window.sirius.Description
  @set 'position', new window.sirius.Position
  @get('position').get('point').push(new window.sirius.Point)

window.sirius.Network::description_text = ->
  @get('description').get('text')

window.sirius.Network::set_description_text = (s) ->
  @get('description').set('text',s)