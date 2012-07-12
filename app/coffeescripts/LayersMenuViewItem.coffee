class window.sirius.LayersMenuViewItem extends Backbone.View
  $a = window.sirius
  tagName : 'li'
  isShowing: true
  
  initialize: (@parent, values) ->
      @triggerShow= values.triggerShow
      @triggerHide= values.triggerHide      
      @template = _.template($('#child-item-menu-template').html())
      displayText = values.label
      displayText = "#{values.label} &raquo; " if values.link
      @$el.html @template({text: displayText}) if values.label
      @$el.attr 'class', values.className if values.className
      @$el.attr 'href', values.href if values.href
      @$el.attr 'id', values.link if values.link
      @events = {'click': values.event } if values.event
      @render()
      @_createSubMenu values.items, values.link if values.link
      @check(true) if values.triggerShow      

  render: ->
    $("##{@parent}").append(@el)
    @
  
  _createSubMenu: (items, id) ->
    new $a.LayersMenuView({className: 'dropdown-menu submenu-hide', id: "sub-#{id}", parentId: id, menuItems: items })

  check: (show) ->
    if show
      @$el.addClass "icon-ok"
    else
      @$el.removeClass "icon-ok"
  
  toggleVisabilty: ->
    if @isShowing
      $a.broker.trigger(@triggerHide)
      @isShowing = false
      @check(false)
    else
      $a.broker.trigger(@triggerShow)
      @isShowing = true
      @check(true)
      