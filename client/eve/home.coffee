Meteor.startup =>
  if not Session.get "eveClient"
    return
  Tracker.autorun ->
    pfleet = Session.get("pendingFleet")
    trust = Session.get("hasTrust")
    if !trust or !pfleet?
      return
    delete Session.keys["pendingFleet"]
    #pfleet = pfleet.replace(/\ /g, "").replace(/\W|_/, "")
    fleet = Fleets.findOne()
    if fleet?
      #check if fleet is is still the same
      if fleet._id is pfleet
        return
      Meteor.call "igbLeaveFleet", Session.get("hostHash"), (err, res)->
        console.log "Attempted to leave fleet automatically"
    #This works because calls are done in order from client
    Meteor.call "joinFleet", Session.get("hostHash"), pfleet, (err, res)->
      if err?
        $.pnotify
          title: "Couldn't Join Fleet"
          text: err.reason
          type: "error"
  Template.eveClient.helpers
    "hasTrust": ->
      Session.get("hasTrust")
  Template.eveGeneralInfo.helpers
    "character": ->
      Characters.findOne()
    "fleet": ->
      Fleets.findOne()
    "pendingFleet": ->
      Session.get "pendingFleet"
  Template.eveGeneralInfo.events
    'click #joinFleetBtn': (e)->
      e.preventDefault()
      Session.set("pendingFleet", $("#fleetID").val())
    'click #leaveFleetBtn': (e)->
      e.preventDefault()
      Meteor.call "igbLeaveFleet", Session.get("hostHash"), (err, res)->
        if err?
          $.pnotify
            title: "Failed"
            text: err.reason
            type: "error"
  Template.requestTrust.events
    'click .requestTrustButton': (e)->
      e.preventDefault()
      requestTrust()

  pathArray = window.location.href.split '/'
  webAddress = pathArray[0]+"//"+pathArray[2]+"/"

  requestTrust = ()->
    eveHandle.requestTrust webAddress+"*"
