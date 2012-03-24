window.aurora.Input::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    link_id = @get('link_id')
    link = object_with_id.link[link_id]
    @set('link', link)
    throw "Input instance can't find link for obj id == #{link_id}" unless link

 window.aurora.Input::encode_references = ->
    @set('link_id', @get('link').id)