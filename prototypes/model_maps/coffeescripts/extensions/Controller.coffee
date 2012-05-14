$a = window.aurora

window.aurora.Controller::initialize = ->
  @set 'parameters', {}
  @set 'planlist', new $a.PlanList()
  @set 'plansequence', new $a.PlanSequence()

window.aurora.Controller::display_point = ->
  if(not @has('display_position'))
    display_position = new $a.Display_position()
    @set 'display_position', display_position
    p = new $a.Point()
    display_position.get('point').push(p)
    pos_elt = null
    if(@has('link'))
      pos_elt = @get('link').get('begin').get('node')
    else if(@has('node'))
      pos_elt = @get('node')
    else if(network)
      pos_elt = @get('network')

    if(pos_elt and pos_elt.has('position') and
       pos_elt.get('position').has('point') and
       pos_elt.get('position').get('point')[0])
      elt_pt = pos_elt.get('position').get('point')[0]
      p.set 'lat', elt_pt.get('lat')
      p.set 'lng', elt_pt.get('lng')
    else
      p.set 'lat', 0
      p.set 'lng', 0

    display_position.get('point')[0]

window.aurora.Controller::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    node_id = @get('node_id')
    link_id = @get('link_id')
    network_id = @get('network_id')
    node = object_with_id.node[node_id]
    link = object_with_id.link[link_id]
    network = object_with_id.network[network_id]
    @set 'node', node
    @set 'link', link
    @set 'network', network

    if !node_id and !link_id and !network_id
      throw "Controller must have node_id, link_id, or network_id"

window.aurora.Controller::encode_references = ->
  @set('node_id', @get('node').id) if @has('node')
  @set('link_id', @get('link').id) if @has('link')
  @set('network_id', @get('network').id) if @has('network')