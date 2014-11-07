Meteor.startup ->
    if not @eveClient
        return
    
    pathArray = window.location.href.split '/'
    webAddress = pathArray[0]+"//"+pathArray[2]+"/"
    
    Session.set("hostHash", Random.id())

    Tracker.autorun ->
        hash = Session.get("hostHash")
        Meteor.subscribe "trust", hash

    Tracker.autorun ->
        character = Characters.findOne()
        if character?
            Meteor.subscribe "igbfleets", Session.get("hostHash")

    Tracker.autorun ->
        trustStatus = TrustStatus.findOne()
        hasTrust = trustStatus? && trustStatus.status
        if Session.get("hasTrust") isnt hasTrust
            Session.set("hasTrust", hasTrust)    #    Session.set("hostHash", hostHash)
        if hasTrust
            Meteor.subscribe "characters", Session.get("hostHash")
    updateRequest = ()->
        HTTP.get webAddress+"background/update", {headers: {ident: Session.get("hostHash")}}, (err, res)->
            if err?
                console.log "Error trying to update the server with our status, "+err
                return
    setInterval(updateRequest, 3000)
    updateRequest()

