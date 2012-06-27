class window.sirius.TreeParentItemView extends Backbone.View
  tagName: "div"
  className: "tree-parent-node"
  
  template: _.template("<%= text %>")
      
  initialize: (element, broker) ->
    @id = "tree-parent-#{element}".toLowerCase().replace(/\ /g,"-")
    $(@el).attr 'id', @id
    @$el.html(@template({text: element}))
    broker.on('app:tree', @render(), @)

  render: ->
    self = @
    $("#tree").append(self.el)