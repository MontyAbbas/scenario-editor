window.sirius.End::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    node_id = @get('node_id')
    node = object_with_id.node[node_id]
    @set 'node', node
    throw "End instance can't find node for obj id = #{node_id}" unless node

window.sirius.End::encode_references = ->
  @set 'node_id', @get('node').id