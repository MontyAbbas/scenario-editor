# This class represents individual items in a context menu.
# Note that the events are passed in as functions and attached to the item
# up on intialization
class window.sirius.ContextMenuItemView extends Backbone.View
  tagName: 'li'

  initialize: (@parent, values) ->
    @template = _.template($('#child-item-menu-template').html())
    @$el.html @template({text: values.label})  if values.label
    @$el.attr 'class', values.className if values.className
    @$el.attr 'id', values.id if values.id
    self = @
    @events = {'click': values.event } if values.event
    @render()
  
  render: () ->
    self = @
    $("##{@parent.options.id}").append(self.el)
    @

