Meteor.setInterval (->
  Session.set "secTimer", new Date()
  return
), 1000
