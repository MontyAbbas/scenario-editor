# This class adds the Parent Items to the Nav Bar
class window.sirius.NavBarView extends Backbone.View
  $a = window.sirius
  tagName: "ul"
  className: "nav"

  initialize: ->
    self = @
    @render()
    for key, values of $a.nav_bar_menu_items
      new $a.NavParentItemView(key)
      for subkey, event of values
         new $a.NavChildItemView(subkey, event, $a.Util.toLowerCaseAndDashed(key))

  render: ->
    self = @
    $("#main-nav div").append(self.el)
    @
