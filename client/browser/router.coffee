Meteor.startup =>
  if eveClient
    return
  Router.map ->
    @route 'home',
      path: '/',
      template: 'browserSplash'
