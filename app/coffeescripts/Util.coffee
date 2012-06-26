class window.sirius.Util
  round_dec = (num,dec) ->
    Math.round(num * Math.pow(10,dec)) / Math.pow(10,dec)

  getLat = (elem) ->
    elem.get('position').get('point')[0].get('lat')

  getLng = (elem) ->
    elem.get('position').get('point')[0].get('lng')

  @getLatLng = (elem) ->
    new google.maps.LatLng(round_dec(getLat(elem),4), round_dec(getLng(elem),4));
