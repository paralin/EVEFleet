Fiber = Npm.require 'fibers'

###
# Fleets Data
#
# name: Fleet Name
# motd: motd..
# fcuser: id of the FC
# active: true/false
#
###

#remove temp stuff on start
TrustStatus.remove({})

makeEvent = (id, message)->
  Events.insert({fleet: id, time: (new Date).getTime(), message: message})

Meteor.methods
  createFleet: (fleetName, motd) ->
    check fleetName, String
    check motd, String
    user = Meteor.user()
    if !user?
      throw new Meteor.Error 403, "You are not logged in"
    fleet = Fleets.findOne({fcuser: user._id, active: true})
    if fleet?
      throw new Meteor.Error 404, "You've already created a fleet."
    if not (4 <= fleetName.length <= 30)
      throw new Meteor.Error 404, "Your fleet name needs to be 4-30 characters."
    newFleet =
      name: fleetName
      motd: motd
      fcuser: user._id
      active: true
    newId = Fleets.insert(newFleet)
    makeEvent(newId, "Fleet created!")
    console.log "Fleet name: "+fleetName+" MOTD: "+motd
  leaveFleet: ->
    user = Meteor.user()
    if !user?
      throw new Meteor.Error 403, "You are not logged in."
    fleet = Fleets.findOne({fcuser: user._id, active: true})
    if !fleet?
      return
    Fleets.update({_id: fleet._id}, {$set: {active: false}})
    Characters.update({fleet: fleet._id}, {$set: {fleet: null}}, {multi: true})
    console.log "FC "+user.username+" has closed fleet "+fleet._id
  joinFleet: (hostHash, fleetID)->
    check hostHash, String
    check fleetID, String
    console.log "Looking up fleet: "+fleetID
    theFleet = Fleets.findOne({_id: fleetID})
    if !theFleet?
      throw new Meteor.Error 404, "Couldn't find that fleet."
    if !theFleet.active
      throw new Meteor.Error 404, "That fleet is not active anymore."
    character = Characters.findOne({hostid: hostHash})
    if !character?
      throw new Meteor.Error 404, "I can't find you in the system."
    if character.fleet isnt fleetID
      Characters.update({_id: character._id}, {$set: {fleet: theFleet._id}})
      console.log "Character '"+character.name+"' joined fleet "+theFleet._id+"."
      makeEvent theFleet._id, character.name+" ("+character.shiptype+") joined."
  igbLeaveFleet: (hostHash)->
    character = Characters.findOne({hostid: hostHash})
    if !character?
      throw new Meteor.Error 404, "I can't find you in the system."
    fleet = Fleets.findOne(_id: character.fleet)
    if fleet?
      console.log fleet
      Characters.update({_id: character._id}, {$set: {fleet: null}})
      makeEvent fleet._id, character.name+" left."

Router.route 'bgupdate',
  where: 'server',
  path: '/background/update',
  action: ->
    if !@request.headers["eve_trusted"]? or !@request.headers["ident"]?
      @response.writeHead 401, {'Content-Type': 'text/html'}
      @response.end "This is a background update method not supported in normal browsers."
      return
    host = @request.connection.remoteAddress
    trusted = @request.headers["eve_trusted"] is "Yes" and @request.headers["eve_serverip"]?
    hostHash = @request.headers["ident"]
    trustStatus = TrustStatus.findOne({ident: hostHash})
    if !trustStatus?
      trustStatus = {ident: hostHash, status: trusted}
      trustStatus._id = TrustStatus.insert(trustStatus)
    if trustStatus.status isnt trusted
      console.log "user "+(if trusted then @request.headers["eve_charname"] else hostHash)+" is now "+(if trusted then "trusted" else "not trusted")
      trustStatus.status = trusted
      TrustStatus.update({_id: trustStatus._id}, {$set: {status: trusted}})
    @response.writeHead 200, {'Content-Type': 'text/html'}
    @response.end ""+hostHash

    if !trusted || !hostHash?
      return

    #parse the new data
    character = Characters.findOne({charId: @request.headers["eve_charid"]})
    headerData =
        charId: @request.headers["eve_charid"]
        name: @request.headers["eve_charname"]
        system: @request.headers["eve_solarsystemname"]
        systemid: parseInt @request.headers["eve_solarsystemid"]
        stationname: @request.headers["eve_stationname"]
        stationid: parseInt @request.headers["eve_stationid"]
        corpname: @request.headers["eve_corpname"]
        corpid: parseInt @request.headers["eve_corpid"]
        alliancename: @request.headers["eve_alliancename"]
        allianceid: parseInt @request.headers["eve_allianceid"]
        shipname: @request.headers["eve_shipname"]
        shipid: parseInt @request.headers["eve_shipid"]
        shiptype: @request.headers["eve_shiptypename"]
        shiptypeid: parseInt @request.headers["eve_shiptypeid"]
        corproles: parseInt @request.headers["eve_corprole"]
        fleet: (if character? then character.fleet else null)
        hostid: hostHash
        active: true
        lastActiveTime: (new Date).getTime()

    for k, v of headerData
        headerData[k] = null if v != v || !v?

    #find the character object
    if !character?
      console.log "new character registered: "+@request.headers["eve_charname"]
      headerData._id = Characters.insert(headerData)
    else
      headerData._id = character._id
      changed = false
      #loop over keys, look for changes
      for k,v of character
        if headerData[k] is undefined
          headerData[k] = null
        if headerData[k] isnt v
          if not (k in ["hostid", "active", "lastActiveTime"])
            console.log character.name+": "+k+" - "+v+" -> "+headerData[k]
            if character? and character.fleet? and k in ["system", "stationname", "shiptype"]
              makeEvent character.fleet, character.name+": "+k+" - "+v+" -> "+headerData[k]
          update = {}
          update[k] = headerData[k]
          if update isnt {}
            Characters.update({_id: character._id}, {$set: update})

checkActiveCharacters = ->
  lastAcceptableTime = (new Date().getTime()) - 10*1000
  Characters.update({active: true, lastActiveTime: {$lt: lastAcceptableTime}}, {$set: {active: false}}, {multi: true})

Meteor.setInterval checkActiveCharacters, 5000
checkActiveCharacters()

String::hashCode = ->
  hash = 0
  i = undefined
  char = undefined
  return hash    if @length is 0
  i = 0
  l = @length

  while i < l
    char = @charCodeAt(i)
    hash = ((hash << 5) - hash) + char
    hash |= 0 # Convert to 32bit integer
    i++
  hash
