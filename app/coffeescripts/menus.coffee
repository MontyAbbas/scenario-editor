$( ->
	$(".jdialog").dialog
		autoOpen: false
		show:
			effect: "drop"
			direction: "left"
			duration: 200
	
		hide:
			effect: "drop"
			direction: "right"
			duration: 200
	
	$('.ui-dialog-titlebar-close').ready () ->
		titlebar = $('.ui-dialog-titlebar-close')
		i = 0;
		while i < titlebar.length
			titlebar[i].innerHTML = '<i class="icon-remove"></i>'
			i++
	
	$("ul > li > a.jmodal").click ->
		navId = @id
		switch navId
			when "nb"
				$("#nodebrowser").dialog "open"
				true
			when "lb"
				$("#linkbrowser").dialog "open"
				true
			when "pb"
				$("#pathbrowser").dialog "open"
				true
			when "eb"
				$("#eventbrowser").dialog "open"
				true
			when "cb"
				$("#controlbrowser").dialog "open"
				true
			when "sb"
				$("#sensorbrowser").dialog "open"
				true
			when "np"
				$("#netprop").dialog "open"
				true
			else
				true
					
	$("#upload").click (e) ->
		$("#uploadField").click()
		e.preventDefault()
)