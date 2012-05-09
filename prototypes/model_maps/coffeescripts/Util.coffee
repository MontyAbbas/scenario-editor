round_dec = (num,dec) ->
		Math.round(num * Math.pow(10,dec)) / Math.pow(10,dec)
		

get_image = (img) ->
		new google.maps.MarkerImage('data/img/' + img + '.png',
				new google.maps.Size(32, 32),
				new google.maps.Point(0,0),
				new google.maps.Point(16, 16));

get_lat = (elem) ->
			elem.get('position').get('point')[0].get('lat')

get_lng = (elem) ->
			elem.get('position').get('point')[0].get('lng')

