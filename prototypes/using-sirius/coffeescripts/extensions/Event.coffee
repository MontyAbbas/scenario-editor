window.sirius.Event::display_point = ->
  display_position = @get('display_position')
  if not display_position
    display_position = new window.sirius.Display_position()
    p = new window.sirius.Point()
    display_position.get('point').push(p)

    pos_elt = null
    if @has('link')
      pos_elt = @get('link').get('begin').get('node')
    else if @has('node')
      pos_elt = @get('node')
    else if @has('network')
      pos_elt = @get('network')

    if pos_elt
      elt_pt = pos_elt.get('position').get('point')[0]
      p.set 'lat', elt_pt.get('lat')
      p.set 'lng', elt_pt.get('lng')
    else
      p.set 'lat', 0
      p.set 'lng', 0

    display_position.get('point')[0]

window.sirius.Event::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    console.log @attributes
    scenario_elements = @get('targetelements').get('scenarioelement')
    console.log scenario_elements
    scenario_links = _.map( scenario_elements, (sel) -> [sel.get('type'), sel.id] )
    _.each(scenario_links, (sl) ->
      [type, sid] = sl
      if type == 'node'
        @set 'node_id', sid
      else if type == 'link'
        @set 'link_id', sid
      else if type == 'network'
        @set 'network_id', sid
      else
        throw new Exception("Unrecognized type in TargetElements: #{type}, id=#{sid}")
    @)
    node_id = @get('node_id')
    link_id = @get('link_id')
    network_id = @get('network_id')
    node = object_with_id.node[node_id]
    link = object_with_id.link[link_id]
    network = object_with_id.network[network_id]
    @set 'node', node
    @set 'link', link
    @set 'network', network

window.sirius.Event::encode_references = ->
  @set('node_id', @get('node').id) if @has('node')
  @set('link_id', @get('link').id) if @has('link')
  @set('network_id', @get('network').id) if @has('network')