Meteor.startup =>
  if Session.get "eveClient"
    return
  Router.map ->
    @route 'home',
      path: '/',
      action: ()->
        user = Meteor.user()
        if !user?
          @render 'browserSplash'
        else
          if Fleets.findOne()?
            @redirect("/fleetCommander/")
            return
          @render 'browserHome'
    @route 'fleetCommander',
      path: '/fleetCommander'
      action: ->
        user = Meteor.user()
        if !user? || !Fleets.findOne()?
          @redirect("/")
          return
        @render "fleetCommander"
    @route 'catchall',
      path: '/*'
      action: ->
        @redirect "/"
