# This class adds the Parent Items to the Nav Bar
class window.sirius.NavParentItemView extends Backbone.View
  $a = window.sirius
  tagName: "li"
  className: "dropdown active"

  initialize: (args) ->
    $(@el).attr 'id', args.textLower
    @parent = args.attach
    @template = _.template($("#parent-item-menu-template").html())
    @$el.html(@template(args))
    $a.broker.on('app:nav-menu', @render, @)
    @render()

  render: ->
    self = @
    $(@parent).append(self.el)
    @

        