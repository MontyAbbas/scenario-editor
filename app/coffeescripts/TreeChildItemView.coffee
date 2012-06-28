class window.sirius.TreeChildItemView extends Backbone.View
  $a = window.sirius
  tagName: "li"
  className: "file"

  initialize: (e, @element) ->
    @model = e
    @id = "tree-item-#{@model.id}"
    $(@el).attr 'id', @id
    displayName =  if @model.get('name')? then @model.get('name') else "No Name Assigned"
    @template = _.template(@_markup())
    @$el.html(@template({text: displayName})) 
    $a.AppView.broker.on('app:tree', @render(), @)

  render: ->
    self = @
    $("#tree-parent-#{@element}").append(self.el)
    @

  _markup: ->
    "<a href=''><%= text %></a>"
