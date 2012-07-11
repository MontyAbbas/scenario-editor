# This class Creates the TreeView by going through the appropriate lists
# and making parent and child nodes for the tree
class window.sirius.TreeView extends Backbone.View
  $a = window.sirius
  tagName: "ol"
  id: "tree"

  # The args contains the scenario models as well as what parent div it should attach the tree too.
  initialize: (args) ->
      scenario = args.scenario
      @parent = args.attach
      links = $a.MapNetworkModel.LINKS
      nodes = $a.MapNetworkModel.NODES
      @_createParentNodes $a.main_tree_elements
      @_createChildren(scenario.get('networklist'), 'network', "network-list", null)
      @_createChildren(scenario.get('networkconnections'), 'network', "network-connections", null)
      @_createChildren(scenario.get('initialdensityset'), 'density', "initial-density-profiles",links)
      @_createChildren(scenario.get('controllerset'), 'controller', "controllers", links)
      @_createChildren(scenario.get('demandprofileset'), 'demandprofile', "demand-profiles", links)
      @_createChildren(scenario.get('eventset'), 'event', "events", links)
      @_createChildren(scenario.get('fundamentaldiagramprofileset'), 'fundamentaldiagramprofile', "fundamental-diagram-profiles", links)
      @_createChildren(scenario.get('oddemandprofileset'), 'oddemandprofile', "od-demand-profiles", links)
      @_createChildren(scenario.get('downstreamboundarycapacityprofileset'), 'downstreamboundarycapacityprofile', "downstream-boundary-profiles", links)
      @_createChildren(scenario.get('splitratioprofileset'), 'splitratioprofile', "split-ratio-profiles",  nodes)
      @_createChildren(scenario.get('sensorlist'), 'sensor', "sensors", links)
      @_createChildren(scenario.get('signallist'), 'signal', "signals", nodes)
      $a.broker.on('app:main_tree', @render, @)
      
  # Attach itself as well as trigger events for the parent and child nodes to be rendered
  render: ->
    self = @
    $(@parent).append(self.el)
    $a.broker.trigger("app:parent_tree")
    $a.broker.trigger("app:child_trees")
    @

  # Creates all the parents nodes and prepares them for rendering
  _createParentNodes : (list) ->
    _.each list, (e) ->  new $a.TreeParentItemView(e)

  # Called by initialize to create the child nodes. If no nodes are defined we add an empty child
  _createChildren : (parentList, modelListName, attach_id, nameList) ->
    if parentList? and parentList.get(modelListName)? and parentList.get(modelListName).length != 0
      @_createChildNodes(parentList.get(modelListName), attach_id, nameList)
    else
      @_createEmptyChild(attach_id)
 
  # If there are no items defined for a parent we add an empty node labelled None Defined
  _createEmptyChild : (attach) ->
    new $a.TreeChildItemView(null, null, "None Defined", attach)
      
  # Creates the child nodes and prepares the for rendering. It is slightly more complex
  # in that the different types of elements have different ways of storing what node
  # or link they are attached to 
  _createChildNodes: (list, attach, nameList) ->
    self = @
    _.each(list, (e) ->
      targets = self._findTargetElements(e, attach, nameList)
      name = targets[0].get('name')
      name = "#{name} -> #{targets[1].get('name')}" if targets.length > 1 #for OD Profiles
      new $a.TreeChildItemView(e, targets, name, attach))

  # We are trying to figure out the target objects for these elements. Again, we case the 
  # type in order to appropriate access the node or link id and then get its name from the node
  # or link list
  _findTargetElements: (element, type, list) ->
    switch type
      when "network-list", "network-connections" then [element]
      when "demand-profiles" then [$a.Util.getElement(element.get('link_id_origin'), list)]
      when "od-demand-profiles" then [$a.Util.getElement(element.get('link_id_origin'), list), $a.Util.getElement(element.get('link_id_destination'), list)]
      when "controllers", "events" then [$a.Util.getElement(element.get('targetelements').get('scenarioelement')[0].get('id'), list)]
      when "fundamental-diagram-profiles", "downstream-boundary-profiles", "initial-density-profiles" then [$a.Util.getElement(element.get('link_id'), list)]
      when "split-ratio-profiles", "signals" then [$a.Util.getElement(element.get('node_id'), list)]
      when "sensors" then [$a.Util.getElement(element.get('link_reference').get('id'), list)]


