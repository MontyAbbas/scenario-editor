# This class adds the Parent Items to the Nav Bar
class window.sirius.NavParentItemView extends Backbone.View
  $a = window.sirius
  tagName: "li"
  className: "dropdown active"

  initialize: (itemName) ->
    $(@el).attr 'id', $a.Util.toLowerCaseAndDashed(itemName)
    @template = _.template(@_markup())
    @$el.html(@template({text: itemName, textLower: $a.Util.toLowerCaseAndDashed(itemName)}))
    $a.broker.on('app:nav-menu', @render(), @)
    @render()

  render: ->
    self = @
    $(".nav").append(self.el)
    @

  _markup: -> 
    mk = "<a class='dropdown-toggle' data-toggle='dropdown' href='#<%= textLower %>'>"
    mk += "<%= text %><b class='caret'></b></a>"
    mk += "<ul class='dropdown-menu'></ul>"
    
    

        