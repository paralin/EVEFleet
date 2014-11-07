pathArray = window.location.href.split '/'
webAddress = pathArray[0]+"//"+pathArray[2]+"/"
hasRendered = false
Session.set "selectedMembersList", "commanders"
Tracker.autorun ->
  route = Router.current()
  if !route?
    return
  if route.template isnt 'fleetCommander'
    hasRendered = false

Template.fleetCommander.rendered = ->
  if hasRendered
    return
  $(".fcContainer").hide().fadeIn(1200)
  hasRendered = true
Template.fcLeftBar.membersSelected = ->
  Session.get "membersSelected"

Template.fcLeftBar.shipsSelected = ->
  Session.get "shipsSelected"

Template.fcLeftBarButtons.membersSelected = Template.fcLeftBar.membersSelected
Template.fcLeftBarButtons.shipsSelected = Template.fcLeftBar.shipsSelected

Template.fcLeftBarButtons.events
  'click #membersButton': ->
    Session.set "membersSelected", true
    Session.set "shipsSelected", false
  'click #shipsButton': ->
    Session.set "membersSelected", false
    Session.set "shipsSelected", true

Template.fcMembersList.events
  'click a': (e)->
    e.preventDefault()
    name = $(e.target).attr("name")
    if !name?
      return
    if name is Session.get "selectedMembersList"
      return
    Session.set "selectedMembersList", $(e.target).attr("name")
  'click .charItem':(e)->
    Session.set "selectedChar", @
  'click #inviteMembersBtn': ->
    window.prompt "Copy the following link to the clipboard and have fleet members open it in the InGame Browser!", webAddress+"f/"+Fleets.findOne()._id

Template.fcMembersList.dockedCharacters = ->
  Characters.find({stationid: {$ne: null}, active: true})
Template.fcMembersList.dockedCharactersCount = ->
  Template.fcMembersList.dockedCharacters().count()
Template.fcMembersList.undockedCharacters = ->
  Characters.find({stationid: null, active: true})
Template.fcMembersList.undockedCharactersCount = ->
  Template.fcMembersList.undockedCharacters().count()

Template.fcShipsList.events
  'click .shiptype-item': (e)->
    e.preventDefault()
    if @id is Session.get "selectedShipsList"
      return
    Session.set "selectedShipsList", @id
  'click .charItem':(e)->
    Session.set "selectedChar", @

Template.fcShipsList.isSelected = ->
  Session.get("selectedShipsList") is @id

Template.fcShipsList.shipTypes = ->
  shipTypes = {}
  for character in Characters.find({active: true}).fetch()
    type = shipTypes[character.shiptypeid] #even capsule has a type
    if !type?
       #even capsule has a type
       type =
         id: character.shiptypeid
         name: character.shiptype
         count: 0
         characters: []
    type.characters.push character
    type.count++
    shipTypes[character.shiptypeid] = type
  result = []
  for k, v of shipTypes
    result.push
      name: v.name
      id: k
      count: v.count
      characters: v.characters
  result

Template.fcMembersList.inactiveCharacters = ->
  Characters.find({active: false})
Template.fcMembersList.inactiveCharactersCount = ->
  Template.fcMembersList.inactiveCharacters().count()

Template.fcLeftBarButtons.undockedShips = Template.fcMembersList.undockedCharactersCount
Template.fcLeftBarButtons.membersCount = ->
  Characters.find({}).count()+1
Template.fcMembersList.commander = ->
  #just us for now
  [Meteor.user()]

Template.fcMembersList.isSelected = (tab)->
  Session.get("selectedMembersList") is tab

Template.fcMapCtrls.rendered = ->
  $("#regionInput").typeahead(
    hint: true
    highlight: true
    minLength: 1
  ,
    name: 'regions'
    displayKey: 'value'
    source: window.ttregions
  )

Template.fcMapCtrls.events
  'keyup #regionInput': ->
    region = $("#regionInput").val()
    console.log region
    console.log regions
    if !(region in regions)
      return
    Session.set "mapRegion", region
  

Template.fcMembersList.rendered = ->
  $("#membersList a[rel=tooltip]").tooltip
    placement: 'right'

Meteor.startup ->
  Session.set "membersSelected", true
  Session.set "shipsSelected", false
