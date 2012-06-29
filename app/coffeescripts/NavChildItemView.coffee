# The view class for each child item in the nav bar view. Each child item
# is an <li> tag with an anchor surrounding the name. 
class window.sirius.NavChildItemView extends Backbone.View
  $a = window.sirius
  tagName: "li"
  
  # The model attribute is the model for this class, the element attribute is 
  # the name of the parent tree element this model should be attached too 
  initialize: (itemText, @parent) ->
    $(@el).attr 'id', $a.Util.toLowerCaseAndDashed(itemText)
    @template = _.template(@_markup())
    @$el.html(@template({text: itemText})) 
    $a.AppView.broker.on('app:nav-menu', @render(), @)
    @render()

  render: ->
    self = @
    $("##{@parent} ul").append(self.el)
    @

  _markup: ->
    "<a href='#'><%= text %></a>"

