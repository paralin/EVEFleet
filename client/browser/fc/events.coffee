Template.fcEvents.events = ->
  Session.get "secTimer"
  Events.find()
Template.fcEvents.niceTime = ->
  moment(@time).fromNow()
