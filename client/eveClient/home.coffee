Meteor.startup =>
  if not @eveClient
    return
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
      Meteor.call "joinFleet", Session.get("hostHash"), $("#fleetID").val(), (err, res)->
        if err?
          $.pnotify
            title: "Failed"
            text: err.reason
            type: "error"
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
    Meteor.subscribe "trust"
    Meteor.subscribe "characters", Session.get("hostHash")
    Deps.autorun ->
      char = Characters.findOne()
      if !char?
        return
      Meteor.subscribe "igbfleets", Session.get("hostHash")
    Deps.autorun ->
      fleet = Fleets.findOne()
      if !fleet?
        return

  pathArray = window.location.href.split '/'
  webAddress = pathArray[0]+"//"+pathArray[2]+"/"

  requestTrust = ()->
    eveHandle.requestTrust webAddress+"*"
