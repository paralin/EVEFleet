Meteor.startup =>
  if eveClient
    return
  Router.map ->
    @route 'home',
      path: '/',
      action: ()->
        user = Meteor.user()
        if !user?
          @render 'browserSplash'
        else
          @render 'browserHome'
