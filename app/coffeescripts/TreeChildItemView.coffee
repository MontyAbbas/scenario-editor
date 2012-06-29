# The view class for each child item in the tree view. Each child item
# is <li> tag with an anchor surrounding the name. 
class window.sirius.TreeChildItemView extends Backbone.View
  $a = window.sirius
  tagName: "li"
  className: "file"

  # The model attribute is the model for this class, the element attribute is 
  # the name of the parent tree element this model should be attached too 
  initialize: (@model, @element) ->
    @id = "tree-item-#{@model.id}"
    $(@el).attr 'id', @id
    displayName =  if @model.get('name')? then @model.get('name') else "No Name Assigned"
    @template = _.template(@_markup())
    @$el.html(@template({text: name})) 
    $a.AppView.broker.on('app:nav', @render(), @)

  render: ->
    self = @
    $("#tree-parent-#{@element}").append(self.el)
    @

  _markup: ->
    "<a href=''><%= text %></a>"
