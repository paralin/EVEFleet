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

Meteor.startup ->
  Session.set "membersSelected", true
  Session.set "shipsSelected", false
