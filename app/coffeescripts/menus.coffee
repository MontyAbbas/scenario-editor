
show_events = true
show_controllers = true
show_sensors = true

window.triggerEvent = (eventName) ->

  switch eventName
    when 'clearMap'
      window.sirius.broker.trigger('map:hide_node_layer')
      window.sirius.broker.trigger('map:hide_link_layer')
      window.sirius.broker.trigger('map:hide_event_layer')
      window.sirius.broker.trigger('map:hide_controller_layer')
      window.sirius.broker.trigger('map:hide_sensor_layer')
      window.sirius.broker.trigger('map:hide_signal_layer')
      window.sirius.MapControllerView.view_controllers = []
      window.sirius.MapControllerView.view_events = []
      window.sirius.MapControllerView.view_nodes = []
      window.sirius.MapControllerView.view_sensors = []
      window.sirius.MapControllerView.view_signals = []
    when 'showAllNodes'
      window.sirius.broker.trigger('map:show_node_layer')
    when 'hideAllNodes'
      window.sirius.broker.trigger('map:hide_node_layer')
    when 'showAllLinks'
      window.sirius.broker.trigger('map:show_link_layer')
    when 'hideAllLinks'
      window.sirius.broker.trigger('map:hide_link_layer:freeway')
    when 'showEvents'
      if show_events
        window.sirius.broker.trigger('map:hide_event_layer')
      else
        window.sirius.broker.trigger('map:show_event_layer')
      show_events = !show_events
    when 'showControllers'
      if show_controllers
        window.sirius.broker.trigger('map:hide_controller_layer')
      else
        window.sirius.broker.trigger('map:show_controller_layer')
      show_controllers = !show_controllers
    when 'showSensors'
      if show_sensors
        window.sirius.broker.trigger('map:hide_sensor_layer')
      else
        window.sirius.broker.trigger('map:show_sensor_layer')
      show_sensors = !show_sensors
  null
  
class window.LayersHandler
  constructor: (id) ->
    @id = id
    menuItems = []
    menuItems.push {
      eventName: 'showAllNodes',
      label: 'Show all nodes'}
    menuItems.push {
      eventName: 'hideAllNodes',
      label: 'Hide all nodes'}
      
    nodeTypeList = []
    nodeTypeList.push {
      eventName: 'freewayNodes',
      label: 'Freeway Nodes'}
    nodeTypeList.push {
      eventName: 'highwayNodes',
      label: 'Highway Nodes'}
    nodeTypeList.push {
      eventName: 'signalXing',
      label: 'Signalized Intersections'}
    nodeTypeList.push {
      eventName: 'stopXing',
      label: 'Stop Intersections'}
    nodeTypeList.push {
      eventName: 'terminals',
      label: 'Terminals'}
    nodeTypeList.push {
      eventName: 'otherNodes',
      label: 'Other'}
    menuItems.push {
      className: 'dropdown submenu',
      link: 'nodeTypeList',
      href: '#nodeTypeList',
      obj: nodeTypeList,
      label: 'Nodes'}
      
    menuItems.push {className: 'divider'}

    menuItems.push {eventName: 'showAllLinks', label: 'Show all links'}
    menuItems.push {eventName: 'hideAllLinks', label: 'Hide all links'}
    linkTypeList = []
    linkTypeList.push {
      eventName: 'freelines',
      label: 'Freeway mainlines'}
    linkTypeList.push {
      eventName: 'highlines',
      label: 'Highway mainlines'}
    linkTypeList.push {
      eventName: 'hovlanes',
      label: 'HOV lanes'}
    linkTypeList.push {
      eventName: 'hotlanes',
      label: 'HOT lanes'}
    linkTypeList.push {
      eventName: 'heavylanes',
      label: 'Heavy vehicle lanes'}
    linkTypeList.push {
      eventName: 'eleclanes',
      label: 'Elec. toll coll. lanes'}
    linkTypeList.push {
      eventName: 'onramps',
      label: 'On-ramps'}
    linkTypeList.push {
      eventName: 'offramps',
      label: 'Off-ramps'}
    linkTypeList.push {
      eventName: 'interconnects',
      label: 'Interconnects'}
    linkTypeList.push {
      eventName: 'streets',
      label: 'Streets'}
    linkTypeList.push {
      eventName: 'dummylinks',
      label: 'Dummy links'}
    menuItems.push {
      className: 'dropdown submenu',
      href: '#linkTypeList',
      link: 'linkTypeList',
      obj: linkTypeList,
      label: 'Links'}
    
    menuItems.push {className: 'divider'}

    menuItems.push {eventName: 'showEvents', label: 'Events'}
    menuItems.push {eventName: 'showControllers', label: 'Controllers'}
    menuItems.push {eventName: 'showSensors', label: 'Sensors'}

    @menuItems_ = menuItems

  createHTML: ->
    f = 0
    createMenuItem = (values) ->
      if values.label
        menuItem = document.createElement 'li'
        child = document.createElement 'a'
        menuItem.appendChild child
        child.innerHTML = values.label
        if values.link
          submenu = document.createElement('ul')
          submenu.className = 'dropdown-menu submenu-hide'
          submenu.setAttribute('id', values.link)
          
          menulink = values.obj
          a = 0
          b = menulink.length
          while a < b
            submenu.appendChild(createMenuItem(menulink[a]))

            a++
          menuItem.appendChild submenu
        
        menuItem.className = values.className if values.className
        menuItem.href = values.href if values.href
        menuItem.onclick = ->
          window.triggerEvent(values.eventName)
        return menuItem
      else
        menuItem = document.createElement 'div'
        menuItem.className = values.className
        return menuItem
    menu = document.createElement('ul')
    menu.className = 'dropdown-menu bottom-up'
    menu.id = 'l_list'
    parent = document.getElementById(@id)
    parent.href="#l_list"

    i = 0
    j = @menuItems_.length
    while i < j
      menu.appendChild createMenuItem(@menuItems_[i])
      i++
    parent.appendChild menu
    @menu_ = menu;
    null
    # possibly add click listener here
  
  attachEvents: ->
    $(".jdialog").dialog
      autoOpen: false
      show:
        effect: "drop"
        direction: "left"
        duration: 200

      hide:
        effect: "drop"
        direction: "right"
        duration: 200

    $(".submenu").hover(->
      $(this).children("ul").removeClass("submenu-hide").addClass "submenu-show"
    , ->
      $(this).children("ul").removeClass("submenu-show").addClass "submenu-hide"
    ).find("a:first").append " &raquo; "

    $('.ui-dialog-titlebar-close').ready ->
      titlebar = $('.ui-dialog-titlebar-close')
      i = 0;
      while i < titlebar.length
        titlebar[i].innerHTML = '<i class="icon-remove"></i>'
        i++


    $("ul > li > a.jmodal").click ->
      navId = @id
      switch navId
        when "nb"
          $("#nodebrowser").dialog "open"
          true
        when "lb"
          $("#linkbrowser").dialog "open"
          true
        when "pb"
          $("#pathbrowser").dialog "open"
          true
        when "eb"
          $("#eventbrowser").dialog "open"
          true
        when "cb"
          $("#controlbrowser").dialog "open"
          true
        when "sb"
          $("#sensorbrowser").dialog "open"
          true
        when "np"
          $("#netprop").dialog "open"
          true
        else
          true

