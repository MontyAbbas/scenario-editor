# A class of static methods used to store general functions used by 
# many classes.
class window.sirius.Util
  @_round_dec: (num,dec) ->
    Math.round(num * Math.pow(10,dec)) / Math.pow(10,dec)

  @_getLat: (elem) ->
    lat = elem.get('position').get('point')[0].get('lat') if elem.get('position')?
    lat = elem.get('display_position').get('point')[0].get('lat') if elem.get('display_position')
    lat 

  @_getLng: (elem) ->
    lng = elem.get('position').get('point')[0].get('lng') if elem.get('position')?
    lng = elem.get('display_position').get('point')[0].get('lng') if elem.get('display_position')
    lng

  # returns a google LatLng obect by retrieving the latitude and longitude from the elements object.
  # In some cases it is stored in position and in others in display_position.
  @getLatLng: (elem) ->
    if @_getLng(elem)? && @_getLat(elem)? then new google.maps.LatLng(@_round_dec(@_getLat(elem),4), @_round_dec(@_getLng(elem),4)) else null
  
  # This method is used by View classes to create id names that are all lowercased and have
  # dashes for spaces
  @toLowerCaseAndDashed: (text) ->
    text.toLowerCase().replace(/\ /g,"-")
  
  # This method is used to grab the model elements from object model by id.
  # The list is the list you want to iterate over and the id is what you want to find
  @getElement: (id, list) ->
    _.find(list, (elem) ->  elem.get('id') == id)  
