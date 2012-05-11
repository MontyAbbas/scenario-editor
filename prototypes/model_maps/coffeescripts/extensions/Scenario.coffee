window.aurora.Scenario.from_xml = (xml) ->
  object_with_id =
    network: {}
    node: {}
    link: {}
    path: {}
    sensor: {}

  sc = window.aurora.Scenario.from_xml1(xml, object_with_id)
  sc.object_with_id = object_with_id

  if sc.has('demandprofileset')
    _.each(sc.get('demandprofileset').get('demand'),
           (demand) ->
              demand.get('link').set('demand', demand)
    )
    sc.get('demandprofileset').set('demand', [])

  if sc.has('capacityprofileset')
    _.each(sc.get('capacityprofileset').get('capacity'),
           (capacity) ->
              capacity.get('link').set('capacity', capacity)
    )
    sc.get('capacityprofileset').set('capacity', [])

  if sc.has('initialdensityprofile')
    _.each(sc.get('initialdensityprofile').get('density'),
           (density) ->
             density.get('link').set('density',density)
    )
    sc.get('initialdensityprofile').set('density', [])

  if sc.has('splitratioprofileset')
    _.each(sc.get('splitratioprofileset').get('splitratios'),
           (splitratios) ->
              splitratios.get('node').set('splitratios', splitratios)
    )
    sc.get('splitratioprofileset').set('splitratios', [])

  sc

window.aurora.Scenario::initialize = ->
  @set('schemaVersion', window.aurora.SchemaVersion)
  @object_with_id = network: {}, node: {}, link: {}, path: {}, sensor: {}
  @set('settings', new window.aurora.Settings())
  @set('network', new window.aurora.Network())

window.aurora.Scenario::network_with_id = (id) ->
  @object_with_id.network[id]

window.aurora.Scenario::node_with_id = (id) ->
  @object_with_id.node[id]

window.aurora.Scenario::link_with_id = (id) ->
  @object_with_id.link[id]

window.aurora.Scenario::set_network_with_id = (id, network) ->
  if network
    @object_with_id.network[id] = network
  else
    delete @object_with_id.network[id]

window.aurora.Scenario::set_node_with_id = (id, node) ->
  if node
    @object_with_id.node[id] = node
  else
    delete @object_with_id.node[id]

window.aurora.Scenario::set_link_with_id = (id, link) ->
  if link
    @object_with_id.link[id] = link
  else
    delete @object_with_id.link[id]

window.aurora.Scenario::stampSchemaVersion = ->
  @set('schemaVersion', window.aurora.SchemaVersion)

window.aurora.Scenario::encode_references = ->
  demandprofileset = @get('demandprofileset')
  capacityprofileset = @get('capacityprofileset')
  initialdensityprofile = @get('initialdensityprofile')
  splitratioprofileset = @get('splitratioprofileset')
  network = @get('network')
  linklist = network.get('linklist') if network
  nodelist = network.get('nodelist') if network

  if demandprofileset && demandprofileset.has('demand')
    demandprofileset.set('demand', [])

  if capacityprofileset && capacityprofileset.has('capacity')
    capacityprofileset.set('capacity', [])

  if initialdensityprofile && initialdensityprofile.has('density')
    initialdensityprofile.set('density', [])

  if splitratioprofileset && splitratioprofileset.has('splitratios')
    splitratioprofileset.set('splitratios', [])

  if linklist and linklist.has('link')
    _.each(linklist.get('link'),
          (link) ->
            if link.has('demand')
              if(!demandprofileset)
                @set('demandprofileset', new window.aurora.DemandProfileSet())
              if(!demandprofileset.has('demand'))
                demandprofileset.set('demand', [])
              demandprofileset.get('demand').push(link.get('demand'))

            if link.has('capacity')
              if(!capacityprofileset)
                @set('capacityprofileset', new window.aurora.CapacityProfileSet())
              if(!capacityprofileset.has('capacity'))
                capacityprofileset.set('capacity',[])
              capacityprofileset.get('capacity').push(link.get('capacity'))

            if link.has('density')
              if(!initialdensityprofile)
                @set('initialdensityprofile', new window.aurora.InitialDensityProfile())
              if(!initialdensityprofile.has('density'))
                initialdensityprofile.set('density', [])
              initialdensityprofile.get('density').push(link.get('density'))
    )

    if nodelist and nodelist.has('node')
      _.each(nodelist.get('node'),
        (node) ->
          if (node.has('splitratios'))
            if(!splitratioprofileset)
              @set('splitratioprofileset', new SplitRatioProfileSet())
            if(!splitratioprofileset.has('splitratios'))
              splitratioprofileset.set('splitratios', [])
            splitratioprofileset.get('splitratios').push(node.get('splitratios'))
      )