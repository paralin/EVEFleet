@eveHandle = @CCPEVE
@eveClient = eveHandle?
Session.set "eveClient", eveClient

Router.configure
  layoutTemplate: 'layout'
$.pnotify.defaults.history = false
$.pnotify.defaults.stack.spacing1 = -5
