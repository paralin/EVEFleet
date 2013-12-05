TrustStatus = new Meteor.Collection "truststat"
Characters = new Meteor.Collection "characters"
Session.set("hasTrust", false)
Session.set("hostHash", Random.id())
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
  Meteor.subscribe "characters", Session.get("hostHash")


requestTrust = ()->
  pathArray = window.location.href.split '/'
  eveHandle.requestTrust(pathArray[0]+"//"+pathArray[2]+"/*")

updateRequest = ()->
  HTTP.get "http://142.129.179.196:3000/background/update", {headers: {ident: Session.get("hostHash")}}, (err, res)->
    if err?
      console.log "Error trying to update the server with our status, "+err
      return
    trustStatus = TrustStatus.findOne({ident: Session.get("hostHash")})
    if Session.get("hasTrust") isnt trustStatus.status
      Session.set("hasTrust", trustStatus.status)  #  Session.set("hostHash", hostHash)
setInterval(updateRequest, 3000)
updateRequest()

