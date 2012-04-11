window.aurora.Link::defaults =
  type: 'ST'
  lanes: 1
  lane_offset: 0
  record: true

window.aurora.Link::initialize = ->
  @set('qmax', new window.aurora.Qmax())
  @set('fd', new window.aurora.Fd())
  @set('dynamics', new window.aurora.Dynamics())

window.aurora.Link::parallel_links = ->
  begin_node = @get('begin').node
  end_node = @get('end').node

  _.filter(begin_node.get('outputs').get('output'),
    (output) ->
      link2 = output.get('link')
      link2 isnt this and link2.get('end').get('node') is end_node
  )