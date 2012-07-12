class window.sirius.LayersMenuViewItem extends Backbone.View
  $a = window.sirius
  @visible = {}
  tagName : 'li'
  isShowing: true
  
  initialize: (@parent, values) ->
      @triggerShow= values.triggerShow
      @triggerHide= values.triggerHide      
      @template = _.template($('#child-item-menu-template').html())
      @$el.html @template({text: values.label}) if values.label
      @$el.attr 'class', values.className if values.className
      @$el.attr 'href', values.href if values.href
      @$el.attr 'id', values.link if values.link
      @events = {'click': values.event } if values.event
      @render()
      @_createSubMenu values.items, values.link if values.link
      @check(true) if values.triggerShow
      
      # if values.eventName and
      # values.eventName != 'showAllNodes' and
      # values.eventName != 'hideAllNodes' and
      # values.eventName != 'showAllLinks' and
      # values.eventName != 'hideAllLinks'
      #   LayersMenuViewItem.visible[values.label] = true
      #   @check(true)

      
      # @menuItem.onclick = (e) ->
      #   $a.broker.trigger("map:#{values.eventName}")
      #   e.stopPropagation()
      # $a.broker.on("map:#{values.eventName}", @doEvent, @)


  
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
      
  doEvent: ->
    visible_ = LayersMenuViewItem.visible
    switch @values.eventName
      when 'showEvents'
        if visible_['Events']
          $a.broker.trigger('map:hide_event_layer')

        else
          $a.broker.trigger('map:show_event_layer')
          @check(true)
        visible_['Events'] = !visible_['Events']
      when 'showControllers'
        if visible_['Controllers']
          $a.broker.trigger('map:hide_controller_layer')
          @check(false)
        else
          $a.broker.trigger('map:show_controller_layer')
          @check(true)
        visible_['Controllers']  = !visible_['Controllers'] 
      when 'showSensors'
        if visible_['Sensors']
          $a.broker.trigger('map:hide_sensor_layer')
          @check(false)
        else
          $a.broker.trigger('map:show_sensor_layer')
          @check(true)
        visible_['Sensors'] = !visible_['Sensors']