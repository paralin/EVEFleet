Meteor.startup =>
  if not @eveClient
    return
  Session.set("hostHash", Random.id())
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

  updateRequest = ()->
    HTTP.get webAddress+"background/update", {headers: {ident: Session.get("hostHash")}}, (err, res)->
      if err?
        console.log "Error trying to update the server with our status, "+err
        return
      trustStatus = TrustStatus.findOne({ident: Session.get("hostHash")})
      if Session.get("hasTrust") isnt trustStatus.status
        Session.set("hasTrust", trustStatus.status)  #  Session.set("hostHash", hostHash)
  setInterval(updateRequest, 3000)
  updateRequest()

