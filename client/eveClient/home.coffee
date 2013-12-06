Meteor.startup =>
  if not @eveClient
    return
  Template.eveClient.hasTrust = ->
    Session.get("hasTrust")
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

  Meteor.startup ->
    Meteor.subscribe "trust"
    Meteor.subscribe "characters", Session.get("hostHash")

  pathArray = window.location.href.split '/'
  webAddress = pathArray[0]+"//"+pathArray[2]+"/"

  requestTrust = ()->
    eveHandle.requestTrust webAddress+"*"


