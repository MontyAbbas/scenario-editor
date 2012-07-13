window.aurora.Begin::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    node = object_with_id.node[@get('node_id')]
    @set 'node', node
    throw "Begin instance can't find node for obj id = #{node_id}" unless node

window.aurora.Begin::encode_references = ->
  @set 'node_id', @get('node').id