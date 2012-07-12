# This class renders the Layers Menu. It's menu items can be found in
# menu-data.coffee. In combination with LayersMenuViewItemit will
# recursively render a menu and its submenus if they are defined
# in the data file correctly.
class window.sirius.LayersMenuView extends Backbone.View
  $a = window.sirius
  tagName : 'ul'
  # used to create hover effects on the submenus
  events : {
      "mouseenter .submenu"   : "hoverSubOn",
      "mouseleave .submenu"   : "hoverSubOff",
      "mouseleave"            : "displayOff",
      "mouseenter"            : "displayOn",
  }
  
  # crete itself, render it and then iterate to create its menu items
  initialize: (@options) ->
    @menuItems = @options.menuItems
    @$el.attr 'class', @options.className if @options.className
    @$el.attr 'id', @options.id if @options.id
    @render()
    self = @
    _.each(self.menuItems, (item) -> new $a.LayersMenuViewItem(self.id, item))
  
  render: ->
    $("##{@options.parentId}").append(@el)
    @
  
  displayOff: (e) =>
    @$el.removeClass "open"
    
  displayOn: (e) =>
    @$el.addClass "open"
  
  # hover events that open and close submenus
  hoverSubOn: (e) =>
    $("##{e.currentTarget.id}").children("ul").removeClass("submenu-hide").addClass "submenu-show"

  hoverSubOff: (e) =>
    $("##{e.currentTarget.id}").children("ul").removeClass("submenu-show").addClass "submenu-hide"
  
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