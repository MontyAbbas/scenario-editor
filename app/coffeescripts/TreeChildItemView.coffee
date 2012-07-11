# The view class for each child item in the tree view. Each child item
# is <li> tag with an anchor surrounding the name. 
class window.sirius.TreeChildItemView extends Backbone.View
  $a = window.sirius
  tagName: "li"
  className: "file"
  events : {
            'click': 'highlight',
            'contextmenu' : 'showContext' 
          }

  # The model attribute is the model for this class, the element attribute is 
  # the name of the parent tree element this model should be attached too 
  initialize: (@model, @targets, name, @element) ->
    # We add an empty node that says None Defined if no children are defined
    if @model?
      @id = "tree-item-#{@targets[0].cid}" 
      $(@el).attr 'id', @id
    displayName =  name
    @template = _.template($('#child-item-menu-template').html())
    @$el.html(@template({text: displayName})) 
    $a.broker.on('app:child_trees', @render, @)
    self = @
    _.each(self.targets, (target) -> 
      $a.broker.on("app:tree_highlight:#{target.cid}", self.highlightOtherSelves, self)
      $a.broker.on("app:tree_remove_highlight:#{target.cid}", self.removeHighlight, self)
      ) if @targets?
    $a.broker.on('app:tree_remove_highlight', @removeHighlight, @)
  
  render: =>
    self = @
    $("#tree-parent-#{@element}").append(self.el)
    @
  
  highlight:  =>
    $a.broker.trigger('map:clear_selected') unless $a.SHIFT_DOWN
    $a.broker.trigger('app:tree_remove_highlight') unless $a.SHIFT_DOWN
    self = @
    _.each(self.targets, (elem) ->
          $a.broker.trigger("app:tree_highlight:#{elem.cid}")
          $a.broker.trigger("map:select_item:#{elem.cid}")
      ) if @targets?
    $a.broker.trigger("map:select_item:#{@model.cid}")
    $(@el).addClass "highlight"

  highlightOtherSelves: () ->
    $(@el).addClass "highlight"
  
  removeHighlight: =>
    $(@el).removeClass "highlight"
  
  # This method adds either the node or links context menu to the tree item.
  # We offset the x and y by 5 in order to make sure the window stays open 
  # once the button is released in FF and we return false to turn off the browsers default
  # context menu
  showContext: (e) =>
    position = {}
    position.x = e.clientX - 5
    position.y = e.clientY - 5
    @targets[0].get('contextMenu').show position
    false