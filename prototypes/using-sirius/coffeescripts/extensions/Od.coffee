window.sirius.Od::initialize = ->
  # TODO probably delete, no obvious PathList replacement in sirius
  #@set('pathlist', new window.sirius.PathList)

window.sirius.Od::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    [n_origin_id, n_destination_id, l_origin_id, l_destination_id] = [
      @get('network_id_origin'),
      @get('network_id_destination'),
      @get('link_id_origin'),
      @get('link_id_destination')
    ]
#    [begin_node, end_node] = [object_with_id.node[begin], object_with_id.node[end]]
    [n_origin, n_destination, l_origin, l_destination] = [
      object_with_id.network[n_origin_id],
      object_with_id.network[n_destination_id],
      object_with_id.link[l_origin_id],
      object_with_id.link[l_destination_id]
    ]
#    @set('begin_node', begin_node)
#    @set('end_node', end_node)
    @set('network_origin', n_origin)
    @set('network_destination', n_destination)
    @set('link_origin', l_origin)
    @set('link_destination', l_destination)

    unless l_origin and l_destination
      throw "Od instance can't find link for id == #{begin}"
    unless n_origin and n_destination
      throw "Od instance can't find network for id == #{end}"

window.sirius.Od::encode_references = ->
  @set('begin', @get('begin_node').id)
  @set('end', @get('end_node').id)