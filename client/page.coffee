Meteor.startup ->
  Template.pageDesign.isBrowser = ->
    not Session.get "eveClient"
  Template.pageDesign.renderLayout = ->
    not (Session.get "eveClient") and Router.current().template isnt "browserSplash"
