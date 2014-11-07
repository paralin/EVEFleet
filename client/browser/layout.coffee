Template.browserlayout.helpers
  "hasFleet": ->
    Fleets.findOne()?
  "fleetName": ->
    Fleets.findOne().name

Template.browserlayout.events
  'click #logoutbtn': ->
    Meteor.logout()
  'click #leavefleetbtn': ->
    Meteor.call "leaveFleet"
