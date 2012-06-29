# This class adds the Parent Items to the Nav Bar
class window.sirius.NavBarView extends Backbone.View
  $a = window.sirius
  tagName: "ul"
  className: "nav"

  initialize: ->
    self = @
    $(".navbar div").append(self.el)
    for key, value of window.nav_bar_menu_items
      new $a.NavParentItemView(key)
      eval window.nav_bar_menu_items_events['Open Local Network']
      _.each(value, (item) -> new $a.NavChildItemView(item, $a.Util.toLowerCaseAndDashed(key)))

  render: ->
    self = @
    $(".navbar div").append(self.el)
    @
