# This class creates the file upload markup
class window.sirius.FileUploadView extends Backbone.View
  $a = window.sirius
  tagName: "input"
  type: "file" 

  initialize: (@name, @id) ->
    $(@el).attr 'type', 'file'
    $(@el).attr 'name', @name
    $(@el).attr 'id', @id
    @events = {'change' : "handleFiles"}
    @render()
  
  render: ->
    self = @
    $("#main-nav div").append(self.el)
    @

  # This function is File upload handler. It will load
  # the xml file, parse it into objects, assign it to window.textarea_scenario, and trigger
  # an event indicating the upload is complete
  handleFiles : ->
    reader = new FileReader()
    self = @
    reader.onloadend = (e) ->
      fileText = e.target.result
      $a.broker.trigger("map:upload_complete", fileText)

    reader.readAsText(@el.files[0])
 