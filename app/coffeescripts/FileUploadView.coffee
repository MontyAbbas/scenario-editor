# This class creates the file upload markup
class window.sirius.FileUploadView extends Backbone.View
  $a = window.sirius
  tagName: "input"
  type: "file" 

  initialize: (@name, @id) ->
    $(@el).attr 'type', 'file'
    $(@el).attr 'name', @name
    $(@el).attr 'id', @id
    @attachEvents()
    @render()
  
  render: ->
    self = @
    $("#main-nav div").append(self.el)
    @
  
  attachEvents: ->
    @events = { 
      'onchange' : (() -> $a.AppView.handleFiles(this.files))
      'onpropertychange' : (() -> $a.AppView.handleFiles(this.files))
    }
   