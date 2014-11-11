Tracker.autorun ->
  if !(Session.get "eveClient")
    if Meteor.user()?
      Meteor.subscribe "browserdata"
