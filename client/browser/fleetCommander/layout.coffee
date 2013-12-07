hasRendered = false
Session.set "selectedMembersList", "commanders"
Deps.autorun ->
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
    lastActive = $("#membersList").children(".active")
    #lastActive.next('div').collapse('hide')
    $(e.target).next('div').collapse('hide')
    Session.set "selectedMembersList", $(e.target).attr("name")
Template.fcMembersList.isSelected = (tab)->
  Session.get("selectedMembersList") is tab

Meteor.startup ->
  Session.set "membersSelected", true
  Session.set "shipsSelected", false
