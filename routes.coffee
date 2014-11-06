#Render the browser splash
Router.onBeforeAction ->
    if Meteor.userId()? || Session.get "eveClient"
        @next()
    else
        @render "browserSplash"

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
