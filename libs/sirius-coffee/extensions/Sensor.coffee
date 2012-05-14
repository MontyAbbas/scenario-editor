window.sirius.Sensor::point = ->
  p = @get('position').get('point')
  p.push(new Point) unless p[0]
  p[0]

window.sirius.Sensor::display_point = ->
  if @has('display_position')
    p = @get('display_position').get('point')[0]
    if not p
      p = new window.sirius.Point
      p.set('lat', @get('lat'))
      p.set('lng', @get('lng'))
      @get('display_position').get('point').push(p)
    p
  else
    @get('point')


  sensor.set('lat', row.lat)
  sensor.set('lng', row.lng)
  sensor.set('elevation', 0)


window.sirius.Sensor::lat = -> @get('point').get('lat')
window.sirius.Sensor::lng = -> @get('point').get('lng')
window.sirius.Sensor::elevation = -> @get('point').get('elevation')
window.sirius.Sensor::display_lat = -> @display_point().get('lat')
window.sirius.Sensor::display_lng = -> @display_point().get('lng')

window.sirius.Sensor::initialize = ->
  @set('position', new window.sirius.Position)

window.sirius.Sensor::defaults =
  parameters: {}

window.sirius.Sensor.from_station_row = (row) ->
  sensor = new window.sirius.Sensor
    description: new window.sirius.Description(text: row.description)
    type: row.type
    link_type: row.link_type
    links: null
    lat: row.lat
    lng: row.lng
    elevation: 0
    display_position: new window.sirius.Display_position()

  sensor.set('link_type', 'HOV') if row.link_type is 'HV'
  sensor.set('link_type', 'FW') if row.link_type is 'ML'

  ### TODO set display_position and parameters ###
  sensor