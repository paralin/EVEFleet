Meteor.startup =>
  if not Session.get "eveClient"
    return
  Router.map ->
    @route 'home',
      path: '/',
      template: 'eveClient'
