# The view class for each child item in the tree view. Each child item
# is <li> tag with an anchor surrounding the name. 
class window.sirius.TreeChildItemView extends Backbone.View
  $a = window.sirius
  tagName: "li"
  className: "file"

  # The model attribute is the model for this class, the element attribute is 
  # the name of the parent tree element this model should be attached too 
  initialize: (@model, name, @element) ->
    @id = "tree-item-#{@model.id}"
    $(@el).attr 'id', @id
    displayName =  name
    @template = _.template($("#child-item-menu-template").html())
    @$el.html(@template({text: displayName})) 
    $a.broker.on('app:child_trees', @render, @)

  render: ->
    self = @
    $("#tree-parent-#{@element}").append(self.el)
    @

