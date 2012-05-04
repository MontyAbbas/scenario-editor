$a = window.sirius

window.sirius.Controller::initialize = ->
  @set 'parameters', {}
  @set 'planlist', new $a.PlanList()
  @set 'plansequence', new $a.PlanSequence()

window.sirius.Controller::display_point = ->
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

window.sirius.Controller::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    scenario_elements = @get('targetelements').get('scenarioelement')
    scenario_links = _.map( scenario_elements, (sel) -> [sel.get('type'), sel.id] )
    _.each(scenario_links, (sl) ->
      [type, sid] = sl
      if type == 'node'
        @set 'node_id', sid
      else if type == 'link'
        @set 'link_id', sid
      else if type == 'network'
        @set 'network_id', sid
      else if type == 'signal'
        @set 'signal_id', sid
      else
        throw "Unrecognized type in TargetElements: #{type}, id=#{sid}"
    @)
    node_id = @get('node_id')
    link_id = @get('link_id')
    network_id = @get('network_id')
    signal_id = @get('signal_id')
    node = object_with_id.node[node_id]
    link = object_with_id.link[link_id]
    network = object_with_id.network[network_id]
    signal = object_with_id.signal[signal_id]
    @set 'node', node
    @set 'link', link
    @set 'network', network
    @set 'signal', signal

    if !node_id and !link_id and !network_id and !signal_id
      throw "Controller must have node_id, link_id, network_id, or signal_id"

window.sirius.Controller::encode_references = ->
  @set('node_id', @get('node').id) if @has('node')
  @set('link_id', @get('link').id) if @has('link')
  @set('network_id', @get('network').id) if @has('network')