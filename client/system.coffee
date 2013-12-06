@eveHandle = @CCPEVE
@eveClient = eveHandle?
Session.set "eveClient", eveClient

Router.configure
  layoutTemplate: 'layout'
