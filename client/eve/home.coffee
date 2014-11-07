Meteor.startup =>
  if not Session.get "eveClient"
    return
  Tracker.autorun ->
    pfleet = Session.get("pendingFleet")
    trust = Session.get("hasTrust")
    if !trust? or !trust
      return
    if pfleet?
      delete Session.keys["pendingFleet"]
      pfleet = pfleet.replace(/\ /g, "").replace(/\W|_/, "")
      if Template.eveGeneralInfo.hasFleet()
        #check if fleet is is still the same
        if Template.eveGeneralInfo.fleetId() is pfleet
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
  Template.eveClient.hasTrust = ->
    Session.get("hasTrust")
  Template.eveGeneralInfo.hasFleet = ->
    char = Characters.findOne()
    if !char?
      return false
    else
      return char.fleet?
  Template.eveGeneralInfo.fleetId = ->
    return Characters.findOne().fleet
  Template.eveGeneralInfo.events
    'click #joinFleetBtn': ->
      Session.set("pendingFleet", $("#fleetID").val())
    'click #leaveFleetBtn': ->
      Meteor.call "igbLeaveFleet", Session.get("hostHash"), (err, res)->
        if err?
          $.pnotify
            title: "Failed"
            text: err.reason
            type: "error"
  Template.eveGeneralInfo.shipType = ->
    char = Characters.findOne()
    if !char?
      "Loading..."
    else
      char.shiptype
  Template.eveGeneralInfo.shipName = ->
    char = Characters.findOne()
    if !char?
      "Loading..."
    else
      char.shipname
  Template.eveGeneralInfo.charName = ->
    char = Characters.findOne()
    if !char?
      "Loading..."
    else
      char.name
  Template.eveGeneralInfo.corpName = ->
    char = Characters.findOne()
    if !char?
      "Loading..."
    else
      char.corpname
  Template.eveGeneralInfo.systemName = ->
    char = Characters.findOne()
    if !char?
      "Loading..."
    else
      char.system
  Template.eveGeneralInfo.stationName = ->
    char = Characters.findOne()
    if !char?
      "Loading..."
    else
      char.stationname
  Template.requestTrust.events
    'click .requestTrustButton': ()->
      requestTrust()
  Template.eveGeneralInfo.fleetName = ->
    fleet = Fleets.findOne()
    return if !fleet?
    fleet.name
  Template.eveGeneralInfo.fleetMOTD = ->
    fleet = Fleets.findOne()
    return if !fleet?
    fleet.motd

  Meteor.startup ->
    Tracker.autorun ->
      char = Characters.findOne()
      if !char?
        return
      if !char.fleet?
        return
      console.log "Fleet: "+char.fleet
      #subscribe to the fleet

  pathArray = window.location.href.split '/'
  webAddress = pathArray[0]+"//"+pathArray[2]+"/"

  requestTrust = ()->
    eveHandle.requestTrust webAddress+"*"
