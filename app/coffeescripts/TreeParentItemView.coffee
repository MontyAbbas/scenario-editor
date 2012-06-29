# The parent items of the tree view. Each parent item
# is a li tag with label for its name, a hidden checkbox that enables 
# us to swap the open/close image easily, and the ol tag for its 
# child elements to be attached to.
class window.sirius.TreeParentItemView extends Backbone.View
  $a = window.sirius
  tagName: "li"
  className: "tree-parent-node"

  initialize: (element) ->
    @template = _.template(@_markup())
    @$el.html(@template({textLower: $a.Util.toLowerCaseAndDashed(element), text: element}))
    $a.AppView.broker.on('app:tree', @render(), @)

  render: ->
    self = @
    $("#tree").append(self.el)
    @

  _markup: -> 
    mk = "<label for='<%= textLower %>'><%= text %></label> "
    mk += "<input type='checkbox' id='check-<%= textLower %>' />"
    mk += "<ol id='tree-parent-<%= textLower %>' ></ol>"
