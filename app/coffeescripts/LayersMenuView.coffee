class window.sirius.LayersMenuView extends Backbone.View
  $a = window.sirius
  
  initialize: (options) ->
    @menuItems = $a.layers_menu
    

  createHTML: ->
    menu = document.createElement('ul')
    menu.className = 'dropdown-menu bottom-up'
    menu.id = 'l_list'
    parent = document.getElementById('lh')
    parent.href="#l_list"
    
   _.each(@menuItems, (item) ->
        menuChild = new LayersMenuViewItem item
        menu.appendChild(menuChild.menuItem)
      )
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