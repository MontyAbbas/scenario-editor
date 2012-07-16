# This class creates the warnings panel and controls its display
class window.sirius.MessagePanelView extends Backbone.View
  $a = window.sirius
  className: 'alert alert-bottom close'
 
  initialize: ->
    @template = _.template($('#message-panel-template').html())
    $a.broker.on("app:show_message", @show, @)
    @render()

  render: ->
    $('body').append(@el)
  
  show: (message, type) =>
    self = @
    @$el.addClass "#{type}"
    @$el.html(@template({message: message})) 
    @$el.fadeIn(4000)
    #@$el.fadeIn(4000, () -> self.$el.fadeOut(4000))
    