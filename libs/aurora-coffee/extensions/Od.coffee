window.aurora.Od::initialize = ->
  @set('pathlist', new window.aurora.PathList)

window.aurora.Od::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    [begin, end] = [@get('begin'), @get('end')]
    [begin_node, end_node] = [object_with_id.node[begin], object_with_id.node[end]]
    @set('begin_node', begin_node)
    @set('end_node', end_node)
    throw "Od instance can't find node for id == #{begin}" unless begin_node
    throw "Od instance can't find node for id == #{end}" unless end_node

window.aurora.Od::encode_references = ->
  @set('begin', @get('begin_node').id)
  @set('end', @get('end_node').id)