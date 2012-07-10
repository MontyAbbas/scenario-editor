class window.LayersHandlerItem extends Backbone.View
  $a = window.sirius
  @visible = {}
  
  initialize: (values) ->
    @values = values
    if values.label
      @menuItem = document.createElement 'li'
      @child = document.createElement 'a'
      @menuItem.appendChild @child
      @child.innerHTML = values.label
      
      if values.eventName and
      values.eventName != 'showAllNodes' and
      values.eventName != 'hideAllNodes' and
      values.eventName != 'showAllLinks' and
      values.eventName != 'hideAllLinks'
        LayersHandlerItem.visible[values.label] = true
        @check(true)
      
      if values.link
        submenu = document.createElement('ul')
        submenu.className = 'dropdown-menu submenu-hide'
        submenu.setAttribute('id', values.link)
        
        menulink = values.obj
        a = 0
        b = menulink.length
        while a < b
          subChild = new LayersHandlerItem(menulink[a])
          submenu.appendChild(subChild.menuItem)
          a++
        @menuItem.appendChild submenu
      
      @menuItem.className = values.className if values.className
      @menuItem.href = values.href if values.href
      @menuItem.onclick = (e) ->
        $a.broker.trigger("map:#{values.eventName}")
        e.stopPropagation()
      $a.broker.on("map:#{values.eventName}", @doEvent, @)
    else
      @menuItem = document.createElement 'div'
      @menuItem.className = values.className
  
  check: (show) ->
    if show
      @child.innerHTML = '<i class="icon-ok"></i> ' + @child.innerHTML
    else
      @child.innerHTML = @values.label
  doEvent: ->
    visible_ = LayersHandlerItem.visible
    switch @values.eventName
      when 'showAllNodes'
        $a.broker.trigger('map:show_node_layer')
      when 'hideAllNodes'
        $a.broker.trigger('map:hide_node_layer')
      when 'showAllLinks'
        $a.broker.trigger('map:show_link_layer')
      when 'hideAllLinks'
        $a.broker.trigger('map:hide_link_layer:freeway')
      when 'showEvents'
        if visible_['Events']
          $a.broker.trigger('map:hide_event_layer')
          @check(false)
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