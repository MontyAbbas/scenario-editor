# This class creates the file upload markup. I didn't create a corresponding 
# model class here. I may in the future
class window.sirius.FileUploadView extends Backbone.View
  $a = window.sirius
  tagName: "input"
  type: "file" 

  initialize: (args) ->
    $(@el).attr 'type', 'file'
    $(@el).attr 'name', args.name
    $(@el).attr 'id', args.id
    @parent = args.attach
    @events = {'change' : "handleFiles"}
    @render()
  
  render: ->
    self = @
    $(@parent).append(self.el)
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
 