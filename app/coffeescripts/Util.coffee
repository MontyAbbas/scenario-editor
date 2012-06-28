class window.sirius.Util
  @_round_dec: (num,dec) ->
    Math.round(num * Math.pow(10,dec)) / Math.pow(10,dec)

  @_getLat: (elem) ->
    elem.get('position').get('point')[0].get('lat')
    lat = elem.get('display_position').get('point')[0].get('lat') if elem.get('display_position')
    lat 

  @_getLng: (elem) ->
    elem.get('position').get('point')[0].get('lng')
    lng = elem.get('display_position').get('point')[0].get('lng') if elem.get('display_position')
    lng

  @getLatLng: (elem) ->
    new google.maps.LatLng(@_round_dec(@_getLat(elem),4), @_round_dec(@_getLng(elem),4));
  
  @toLowerCaseAndDashed: (text) ->
    text.toLowerCase().replace(/\ /g,"-")
