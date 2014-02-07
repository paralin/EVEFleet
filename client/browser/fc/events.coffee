Template.fcEvents.events = ->
  Events.find()
Template.fcEvents.niceTime = ->
  #moment(@time).format("h:mm:ss")
  moment(@time).fromNow()
