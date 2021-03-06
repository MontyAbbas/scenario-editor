window.aurora.Capacity::defaults =
  dt: 1
  start_time: 0

window.aurora.Capacity::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    link = object_with_id.link[@get('link_id')]
    @set 'link', link
    throw "Begin instance can't find link for obj id = #{node_id}" unless link
    link.set 'capacity', @

window.aurora.Capacity::encode_references = ->
  @set 'link_id', @get('link').id