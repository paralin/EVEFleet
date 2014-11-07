@eveHandle = @CCPEVE
@eveClient = eveHandle?
#if @eveClien#t
#    window.location.href = "http://google.com"
Session.set "eveClient", eveClient

Template.body.helpers
    "renderRouter": ->
        not Session.get "eveClient"
