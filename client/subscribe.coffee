Tracker.autorun ->
    if Session.get "eveClient"
        Meteor.subscribe "fleet"
    else
        if Meteor.user()?
            Meteor.subscribe "fleet"
