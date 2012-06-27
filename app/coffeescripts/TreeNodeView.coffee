class window.sirius.TreeNodeView extends Backbone.View
  tagName: "li"
  className: "node"
  
  template: _.template("<%= text %>")
      
  initialize: (element, broker) ->
    @id = "node-#{element}"
    $(@el).attr 'id', @id
    @$el.html(@template({text: element}))
    broker.on('app:tree', @render(), @)

  render: ->
    self = @
    $("#tree").append(self.el);