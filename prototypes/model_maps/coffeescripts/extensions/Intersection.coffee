window.aurora.Intersection::defaults =
  stage: []

window.aurora.Intersection::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    node_id = @get('node_id')
    node = object_with_id.node[node_id]
    @set('node',node)
    throw "Intersection instance can't find node obj id == #{node_id}" unless node

window.aurora.Intersection::encode_references = ->
  @set('node_id', @get('node').id)