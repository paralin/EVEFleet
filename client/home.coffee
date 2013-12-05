eveHandle = @CCPEVE
Template.page.hasTrust = ->
  hasTrust()
Template.generalInfo.shipType = ->
  headers.get "eve_shiptypename"
Template.generalInfo.shipName = ->
  headers.get "eve_shipname"
Template.generalInfo.charName = ->
  headers.get "eve_charname"
Template.generalInfo.corpName = ->
  headers.get "eve_corpname"
Template.generalInfo.systemName = ->
  headers.get "eve_solarsystemname"
Template.generalInfo.stationName = ->
  headers.get "eve_stationname"
Template.generalInfo.allHeaders = ->
  EJSON.stringify headers.get()
Template.requestTrust.events
  'click .requestTrustButton': ()->
    requestTrust()

hasTrust = ->
  (headers.get "eve_trusted") is "Yes"

requestTrust = ()->
  pathArray = window.location.href.split '/'
  eveHandle.requestTrust(pathArray[0]+"//"+pathArray[2]+"/*")
