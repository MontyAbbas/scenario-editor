# Somewhat ripped from http://documentcloud.github.com/backbone/docs/todos.html
# but more primitive because persistence/deep interaction doesn't matter
jQuery ->
	window.Item = Backbone.Model.extend
		defaults: ->
			icon: 'heart'
			text: 'default text'
			order: Items.nextOrder

	window.ItemList = Backbone.Collection.extend
		model: Item
		nextOrder: ->
			1 if this.length?
			this.last().get('order') + 1
		comparator: (item) ->
			item.get('order')

	window.Items = new ItemList

	window.ItemView = Backbone.View.extend
		tagName: 'li'
		template: _.template($('#item-template').html())
		setText: ->
			text = this.model.get('text')
			this.$('.item-text').text(text)
			console.log(text)
		setIcon: ->
			icon = this.model.get('icon')
			console.log("icon-#{icon}")
			this.$('.item-icon').removeClass('item-icon').addClass("icon-#{icon}")
		render: ->
			$(@el).html(@template(@model.toJSON()))
			this.setText()
			this.setIcon()
			this

	window.AppView = Backbone.View.extend
		el: $('#itemapp')
		initialize: ->
			@input = this.$('#new-item')
			Items.bind('add', this.addOne, this)
		events:
			"click #save-item": "createItem"
		createItem: ->
			Items.add(new Item(text: @input.val()))
			@input.val('')
		addOne: (item) ->
			view = new ItemView(model: item)
			$('#item-list').append(view.render().el)

	window.App = new AppView
