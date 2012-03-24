window.aurora.Sensor::point = ->
  p = @get('position').get('point')
  p.push(new Point) unless p[0]
  p[0]

window.aurora.Sensor::display_point = ->
  if @has('display_position')
    p = @get('display_position').get('point')[0]
    if not p
      p = new window.aurora.Point
      p.set('lat', @get('lat'))
      p.set('lng', @get('lng'))
      @get('display_position').get('point').push(p)
    p
  else
    @get('point')


  sensor.set('lat', row.lat)
  sensor.set('lng', row.lng)
  sensor.set('elevation', 0)


window.aurora.Sensor::lat = -> @get('point').get('lat')
window.aurora.Sensor::lng = -> @get('point').get('lng')
window.aurora.Sensor::elevation = -> @get('point').get('elevation')
window.aurora.Sensor::display_lat = -> @display_point().get('lat')
window.aurora.Sensor::display_lng = -> @display_point().get('lng')

window.aurora.Sensor::initialize = ->
  @set('position', new window.aurora.Position)

window.aurora.Sensor::defaults =
  parameters: {}

window.aurora.Sensor.from_station_row = (row) ->
  sensor = new window.aurora.Sensor
    description: new window.aurora.Description(text: row.description)
    type: row.type
    link_type: row.link_type
    links: null
    lat: row.lat
    lng: row.lng
    elevation: 0
    display_position: new window.aurora.Display_position()

  sensor.set('link_type', 'HOV') if row.link_type is 'HV'
  sensor.set('link_type', 'FW') if row.link_type is 'ML'

  ### TODO set display_position and parameters ###
  sensor