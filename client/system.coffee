@eveHandle = @CCPEVE
@eveClient = eveHandle?
#if @eveClien#t
#    window.location.href = "http://google.com"
Session.set "eveClient", eveClient
