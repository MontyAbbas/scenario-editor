class window.LayersHandler extends Backbone.View
  $a = window.sirius
  
  initialize: (options) ->
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
    menu = document.createElement('ul')
    menu.className = 'dropdown-menu bottom-up'
    menu.id = 'l_list'
    parent = document.getElementById('lh')
    parent.href="#l_list"
    
    i = 0
    j = @menuItems_.length
    while i < j
      menuChild = new LayersHandlerItem @menuItems_[i]
      menu.appendChild(menuChild.menuItem)
      i++
    parent.appendChild menu
    @menu_ = menu;
    this
  
  clearMap: ->
    $a.broker.trigger('map:hide_node_layer')
    $a.broker.trigger('map:hide_link_layer')
    $a.broker.trigger('map:hide_event_layer')
    $a.broker.trigger('map:hide_controller_layer')
    $a.broker.trigger('map:hide_sensor_layer')
    $a.broker.trigger('map:hide_signal_layer')
    $a.MapControllerView.removeAll()
    $a.MapEventView.removeAll()
    $a.MapLinkView.removeAll()
    $a.MapNodeView.removeAll()
    $a.MapSensorView.removeAll()
    $a.MapSignalView.removeAll()
    $a.MapNetworkModel.removeAll()
  
  
  showAlert: ->
    alertBox = document.createElement 'div'
    alertBox.className = 'alert alert-bottom'
    alertBox.innerHTML = 'Loaded map'
    bod = document.getElementById 'body'
    bod.appendChild alertBox
    
  attachEvents: ->
    $a.broker.on("map:clearMap", @clearMap, @)
    $a.broker.on("map:alert", @showAlert, @)
    
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