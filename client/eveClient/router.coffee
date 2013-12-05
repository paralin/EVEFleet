Meteor.startup =>
  if not eveClient
    return
  Router.map ->
    @route 'home',
      path: '/',
      template: 'eveClient'
