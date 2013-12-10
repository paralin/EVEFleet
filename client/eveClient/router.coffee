Meteor.startup =>
  if not Session.get "eveClient"
    return
  Router.map ->
    @route 'home',
      path: '/',
      template: 'eveClient'
    @route 'fleetInvite',
      path: '/f/:_id',
      action: ->
        Session.set("pendingFleet", @params._id)
        @render "eveClient"
        $.pnotify
          title: "Joining fleet..."
          text: "Will attempt to join fleet "+@params._id+" shortly..."
          closer: false
          sticker: false
          delay: 2000

