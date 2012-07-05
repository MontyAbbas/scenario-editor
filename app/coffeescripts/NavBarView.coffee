# This class adds the Parent Items to the Nav Bar
class window.sirius.NavBarView extends Backbone.View
  $a = window.sirius
  tagName: "ul"
  className: "nav"

  initialize: (args) ->
    self = @
    @parent = args.attach
    @render()
    for key, values of args.menuItems
      keyLower = $a.Util.toLowerCaseAndDashed(key)
      new $a.NavParentItemView({text: key, textLower: keyLower, attach: ".#{@className}"})
      for subkey, event of values
         new $a.NavChildItemView({text: subkey, textLower: $a.Util.toLowerCaseAndDashed(subkey), event: event, attach: keyLower})

  render: ->
    self = @
    $(@parent).append(self.el)
    @
