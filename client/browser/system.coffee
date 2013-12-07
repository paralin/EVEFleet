Deps.autorun ->
  user = Meteor.user()
  Meteor.subscribe "bcharacters"
  Meteor.subscribe "fleetEvents"
