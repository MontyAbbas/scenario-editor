window.sirius.Link::defaults =
  type: 'ST'
  lanes: 1
  lane_offset: 0
  record: true

window.sirius.Link::initialize = ->
  # TODO probably delete qmax line, change fd line to FundamentalDiagram
  #@set('qmax', new window.sirius.Qmax())
  #@set('fd', new window.sirius.Fd())
  @set('dynamics', new window.sirius.Dynamics())

window.sirius.Link::parallel_links = ->
  begin_node = @get('begin').node
  end_node = @get('end').node

  _.filter(begin_node.get('outputs').get('output'),
    (output) ->
      link2 = output.get('link')
      link2 isnt this and link2.get('end').get('node') is end_node
  )