Template.browserlayout.events
  'click #logoutbtn': ->
    Meteor.logout()
Template.browserlayout.hasFleet = ->
  Fleets.findOne()?
