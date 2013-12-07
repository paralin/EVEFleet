Template.browserlayout.events
  'click #logoutbtn': ->
    Meteor.logout()
  'click #leavefleetbtn': ->
    Meteor.call "leaveFleet"
Template.browserlayout.hasFleet = ->
  Fleets.findOne()?
Template.browserlayout.fleetName = ->
  Fleets.findOne().name+" - "+Fleets.findOne()._id
