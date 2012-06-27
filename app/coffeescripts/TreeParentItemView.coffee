class window.sirius.TreeParentItemView extends Backbone.View
  $a = window.sirius
  tagName: "div"
  className: "tree-parent-node"
  
  template: _.template("> <%= text %>")
      
  initialize: (element) ->
    @id = "tree-parent-#{element}".toLowerCase().replace(/\ /g,"-")
    $(@el).attr 'id', @id
    @$el.html(@template({text: element}))
    $a.AppView.broker.on('app:tree', @render(), @)

  render: ->
    self = @
    $("#tree").append(self.el)