window.sirius.Density::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    link_id = @get('link_id')
    link = object_with_id.link[link_id]
    @set 'link', link
    throw "Density instance can't find link for obj id = #{link_id}" unless link
    link.set 'density', @

window.sirius.Density::encode_references = ->
  @set('link_id', @get('link').id)