Template.pageDesign.isBrowser = ->
  not Session.get "eveClient"
Template.pageDesign.renderLayout = ->
  loggedIn = Meteor.user()?
  not (Session.get "eveClient") and loggedIn
