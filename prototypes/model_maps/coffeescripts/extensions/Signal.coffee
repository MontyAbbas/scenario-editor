window.aurora.Signal::defaults =
  phase: []

window.aurora.Signal::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    node_id = @get('node_id')
    node = object_with_id.node[node_id]
    @set 'node', node
    throw "Signal instance can't find node for obj id == #{node_id}" unless node
    node.set('signal', @)

window.aurora.Signal::encode_references = ->
  @set 'node_id', @get('node').id

window.aurora.Signal::phase_with_nema = (nema) ->
  _.find(@get('phase'), (phase) -> phase.get('nema') == nema)

window.aurora.Signal::calc_phase_row_col = ->
  _.each(@get('phase'),
    (ph) ->
      nema = ph.get('nema')
      if nema <= 4
        ph.row = 0
      else
        ph.row = 1
      ph.set('column', (nema-1) % 4)
  )

  _.each(@get('phase'),
    (ph) ->
      if(ph.has('lag'))
        if(nema % 2 == 1)
          alt_ph = @phase_with_nema(nema + 1)
          ph.set('column', 1 + ph.get('column'))
          alt_ph.set('column', alt_ph.get('column') - 1)
        else
          trace("phase cannot have lag=true and nema=#{nema}")
  )