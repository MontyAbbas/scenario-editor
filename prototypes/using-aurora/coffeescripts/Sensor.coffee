class window.aurora.Sensor extends Backbone.Model
  ### $a = alias for aurora namespace ###
  $a = window.aurora
  @from_xml1: (xml, object_with_id) ->
    deferred = []
    obj = @from_xml2(xml, deferred, object_with_id)
    fn() for fn in deferred
    obj
  
  @from_xml2: (xml, deferred, object_with_id) ->
    return null if not xml
    obj = new window.aurora.Sensor()
    description = xml.find('description')
    obj.set 'description', $a.Description.from_xml2(description, deferred, object_with_id)
    position = xml.find('position')
    obj.set 'position', $a.Position.from_xml2(position, deferred, object_with_id)
    display_position = xml.find('display_position')
    obj.set 'display_position', $a.Display_position.from_xml2(display_position, deferred, object_with_id)
    links = xml.find('links')
    obj.set 'links', $a.Links.from_xml2(links, deferred, object_with_id)
    parameters = xml.find('parameters')
    obj.set 'parameters', _.reduce(parameters.find("parameter"),
          (acc,par_xml) ->
            acc[par_xml.attr('name')] = par_xml.attr('value')
            acc
          {}
    )
    data_sources = xml.find('data_sources')
    obj.set 'data_sources', $a.Data_sources.from_xml2(data_sources, deferred, object_with_id)
    id = $(xml).attr('id')
    obj.set 'id', xml.id
    type = $(xml).attr('type')
    obj.set 'type', xml.type
    link_type = $(xml).attr('link_type')
    obj.set 'link_type', xml.link_type
    if obj.resolve_references
      obj.resolve_references(deferred, object_with_id)
    obj
  
  to_xml: (doc) ->
    xml = doc.createElement('sensor')
    if @encode_references
      @encode_references()
    xml.appendChild(@get('description').to_xml()) if @has('description')
    xml.appendChild(@get('position').to_xml()) if @has('position')
    xml.appendChild(@get('display_position').to_xml()) if @has('display_position')
    xml.appendChild(@get('links').to_xml()) if @has('links')
    if @has('parameters')
      parameters_xml = doc.createElement('parameters')
      _.each(@get('parameters'), (par_name) ->
          parameter_xml = doc.createElement('parameter')
          parameter_xml.setAttribute(par_name, parameters[par_name])
          parameters_xml.appendChild(parameter_xml)
      )
      xml.appendChild(parameters_xml)
    
    xml.appendChild(@get('data_sources').to_xml()) if @has('data_sources')
    xml.setAttribute('id', @get('id'))
    xml.setAttribute('type', @get('type'))
    xml.setAttribute('link_type', @get('link_type'))
    xml
  
  deep_copy: -> Sensor.from_xml1(@to_xml(), {})
  inspect: (depth = 1, indent = false, orig_depth = -1) -> null
  make_tree: -> null