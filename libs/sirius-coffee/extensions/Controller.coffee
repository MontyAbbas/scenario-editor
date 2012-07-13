$a = window.sirius

window.sirius.Controller::initialize = ->
  @set 'parameters', {}
  @set 'planlist', new $a.PlanList()
  @set 'plansequence', new $a.PlanSequence()

window.sirius.Controller::display_point = ->
  if(not @has('display_position'))
    display_position = new $a.Display_position()
    @set 'display_position', display_position
    p = new $a.Point()
    display_position.get('point').push(p)
    pos_elt = null
    if(@has('link'))
      pos_elt = @get('link').get('begin').get('node')
    else if(@has('node'))
      pos_elt = @get('node')
    else if(network)
      pos_elt = @get('network')

    if(pos_elt and pos_elt.has('position') and
       pos_elt.get('position').has('point') and
       pos_elt.get('position').get('point')[0])
      elt_pt = pos_elt.get('position').get('point')[0]
      p.set 'lat', elt_pt.get('lat')
      p.set 'lng', elt_pt.get('lng')
    else
      p.set 'lat', 0
      p.set 'lng', 0

    display_position.get('point')[0]

window.sirius.Controller::resolve_references = (deferred, object_with_id) ->
  deferred.push =>
    @set 'id', @get('id')
    @set('targetreferences',[]);
    _.each(@get('targetelements').get('scenarioElement'), (e) -> 
      switch e.type
        when 'link' then @get('targetreferences').push object_with_id.link[e.id]
        when 'node' then @get('targetreferences').push object_with_id.node[e.id]
        when 'controller' then @get('targetreferences').push object_with_id.controller[e.id]
        when 'sensor' then @get('targetreferences').push object_with_id.sensor[e.id]
        when 'event' then @get('targetreferences').push object_with_id.event[e.id]
        when 'signal' then @get('targetreferences').push object_with_id.signal[e.id]
    )

    # if @get('targetreferences').length == 0
    #    throw "Event must have target elements defined"
    

window.sirius.Controller::encode_references = ->
  # TODO : do we to encode references? All the data will be written back via scenarioElements
  # @set('node_id', @get('node').id) if @has('node')
  # @set('link_id', @get('link').id) if @has('link')
  # @set('network_id', @get('network').id) if @has('network')