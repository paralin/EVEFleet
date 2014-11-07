#Render the browser splash
Router.onBeforeAction ->
    if Meteor.isServer || (Session.get "eveClient") || Meteor.userId()?
        @next()
    else
        @render "browserSplash"
#
#Render the IGB shit
Router.onBeforeAction ->
    if Meteor.isServer || !(Session.get "eveClient")
        @next()
    else
        @render "eveClient"

Router.route '/', ->
    if Fleets.findOne()?
        @redirect '/commander'
    else
        @layout 'browserlayout'
        @render 'browserHome'

Router.route '/commander', ->
    if !Fleets.findOne()?
        @redirect '/'
    else
        @layout 'browserlayout'
        @render 'fleetCommander'
