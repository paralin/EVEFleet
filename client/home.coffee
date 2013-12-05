TrustStatus = new Meteor.Collection "truststat"
Characters = new Meteor.Collection "characters"
Session.set("hasTrust", false)
Session.set("hostHash", 0)
hostHash = 0
eveHandle = @CCPEVE
Template.page.hasTrust = ->
  Session.get("hasTrust")
Template.generalInfo.shipType = ->
  char = Characters.findOne()
  if !char?
    "Loading..."
  else
    char.shiptype
Template.generalInfo.shipName = ->
  char = Characters.findOne()
  if !char?
    "Loading..."
  else
    char.shipname
Template.generalInfo.charName = ->
  char = Characters.findOne()
  if !char?
    "Loading..."
  else
    char.name
Template.generalInfo.corpName = ->
  char = Characters.findOne()
  if !char?
    "Loading..."
  else
    char.corpname
Template.generalInfo.systemName = ->
  char = Characters.findOne()
  if !char?
    "Loading..."
  else
    char.system
Template.generalInfo.stationName = ->
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


requestTrust = ()->
  pathArray = window.location.href.split '/'
  eveHandle.requestTrust(pathArray[0]+"//"+pathArray[2]+"/*")

updateRequest = ()->
  HTTP.get "http://10.0.1.2:3000/background/update", (err, res)->
    if err?
      console.log "Error trying to update the server with our status, "+err
      return
    hostHash = parseInt res.content
    if Session.get("hostHash") isnt hostHash
      Session.set("hostHash", hostHash)
setInterval(updateRequest, 3000)
updateRequest()


#Update logic for trust status
Deps.autorun ->
  hostHash = Session.get("hostHash")
  console.log "hostHash: "+hostHash
  if hostHash is 0
    return
  trustStatus = TrustStatus.findOne({ident: Session.get("hostHash")}).status
  if Session.get("hasTrust") isnt trustStatus
    Session.set("hasTrust", trustStatus)
  Meteor.subscribe "characters", Session.get("hostHash")
