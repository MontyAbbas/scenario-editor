window.aurora.Node::input_indexes = (other_node) ->
  _.map(@get('inputs').get('input'),
    (input, idx) ->
      link = input.get('link')
      [link, index] if link.get('begin').get('node') == other_node
  )

window.aurora.Node::output_indexes = (other_node) ->
  _.map(@get('outputs').get('output'),
    (output, idx) ->
      link = output.get('link')
      [link, index] if link.get('end').get('node') == other_node
  )

window.aurora.Node::terminal = ->
  @get('type') is 'T'

window.aurora.Node::signalized = ->
  @get('type') is 'S'