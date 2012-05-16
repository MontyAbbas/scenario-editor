class window.aurora.Util
	round_dec = (num,dec) ->
			Math.round(num * Math.pow(10,dec)) / Math.pow(10,dec)

	get_image = (img) ->
	

	get_lat = (elem) ->
			elem.get('position').get('point')[0].get('lat')

	get_lng = (elem) ->
			elem.get('position').get('point')[0].get('lng')

