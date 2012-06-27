class window.sirius.TreeChildItemView extends Backbone.View
  $a = window.sirius
  tagName: "li"
  className: "tree-child-node"
  
  template: _.template("<%= text %>")
      
  initialize: (e, @element) ->
    @model = e
    @id = "tree-item-#{@model.id}"
    $(@el).attr 'id', @id
    @$el.html(@template({text: @model.get('name')}))
    $a.AppView.broker.on('app:tree', @render(), @)

  render: ->
    self = @
    $("#tree-parent-#{@element}").append(self.el)