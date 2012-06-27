class window.sirius.Util
  round_dec = (num,dec) ->
    Math.round(num * Math.pow(10,dec)) / Math.pow(10,dec)

  getLat = (elem) ->
    lat = elem.get('position').get('point')[0].get('lat') if elem.get('position')
    lat = elem.get('display_position').get('point')[0].get('lat') if elem.get('display_position')
    lat 

  getLng = (elem) ->
    lng = elem.get('position').get('point')[0].get('lng') if elem.get('position')
    lng = elem.get('display_position').get('point')[0].get('lng') if elem.get('display_position')
    lng

  @getLatLng = (elem) ->
    new google.maps.LatLng(round_dec(getLat(elem),4), round_dec(getLng(elem),4));
