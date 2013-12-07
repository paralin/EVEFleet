Characters = new Meteor.Collection "characters"
PendingTrust = new Meteor.Collection "truststat"
Fleets = new Meteor.Collection "fleets"

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
PendingTrust.remove({})

Meteor.publish "trust", ()->
  PendingTrust.find({})

Meteor.publish "characters", (hostHash)->
  Characters.find({hostid: hostHash})

Meteor.publish "bcharacters", ->
  user = Meteor.users.findOne({_id: @userId})
  if !user?
    return
  fleet = Fleets.findOne({fcuser: @userId})
  if !fleet?
    return
  Characters.find({fleet: fleet._id})

Meteor.publish "fleets", ->
  Fleets.find({fcuser: @userId, active: true})
Meteor.publish "igbfleets", (userHash) ->
  check userHash, String
  char = Characters.findOne({hostid: userHash})
  if !char?
    return
  #console.log char.fleet
  fleets = Fleets.find({_id: char.fleet, active: true})
  console.log fleets.fetch()[0]
  return fleets
Meteor.publish "fleetCharacters", ->
  user = Meteor.users.findOne({_id: @userId})
  if !user?
    return
  fleet = Fleets.findOne({fcuser: @userId, active: true})
  if !fleet?
    return
  Characters.find({fleet: fleet._id})

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
    Fleets.insert(newFleet)
    console.log "Fleet name: "+fleetName+" MOTD: "+motd
  leaveFleet: ->
    user = Meteor.user()
    if !user?
      throw new Meteor.Error 403, "You are not logged in."
    fleet = Fleets.findOne({fcuser: user._id, active: true})
    if !fleet?
      return
    Fleets.update({_id: fleet._id}, {$set: {active: false}})
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
    Characters.update({_id: character._id}, {$set: {fleet: theFleet._id}})
    console.log "Character '"+character.name+"' joined fleet "+theFleet._id+"."
  igbLeaveFleet: (hostHash)->
    character = Characters.findOne({hostid: hostHash})
    if !character?
      throw new Meteor.Error 404, "I can't find you in the system."
    Characters.update({_id: character._id}, {$set: {fleet: undefined}})

Router.map ->
  @route 'bgupdate',
    where: 'server',
    path: '/background/update',
    action: ->
      if !@request.headers["eve_trusted"]? or !@request.headers["ident"]?
        @response.writeHead 401, {'Content-Type': 'text/html'}
        @response.end "This is not supported in normal browsers."
        return
      host = @request.connection.remoteAddress
      trusted = @request.headers["eve_trusted"] is "Yes"
      hostHash = @request.headers["ident"]
      trustStatus = PendingTrust.findOne({ident: hostHash})
      if !trustStatus?
        trustStatus = {ident: hostHash, status: trusted}
        trustStatus._id = PendingTrust.insert(trustStatus)
      if trustStatus.status isnt trusted
        console.log "user "+(if trusted then @request.headers["eve_charname"] else hostHash)+" is now "+(if trusted then "trusted" else "not trusted")
        trustStatus.status = trusted
        PendingTrust.update({_id: trustStatus._id}, {$set: {status: trusted}})
      @response.writeHead 200, {'Content-Type': 'text/html'}
      @response.end ""+hostHash

      if !trusted
        return

      #parse the new data
      character = Characters.findOne({charId: @request.headers["eve_charid"]})
      headerData =
          charId: @request.headers["eve_charid"]
          name: @request.headers["eve_charname"]
          system: @request.headers["eve_solarsystemname"]
          systemid: @request.headers["eve_solarsystemid"]
          stationname: @request.headers["eve_stationname"]
          stationid: @request.headers["eve_stationid"]
          corpname: @request.headers["eve_corpname"]
          corpid: @request.headers["eve_corpid"]
          alliancename: @request.headers["eve_alliancename"]
          allianceid: @request.headers["eve_allianceid"]
          shipname: @request.headers["eve_shipname"]
          shipid: @request.headers["eve_shipid"]
          shiptype: @request.headers["eve_shiptypename"]
          shiptypeid: @request.headers["eve_shiptypeid"]
          fleet: (if character? then character.fleet else null)
          hostid: hostHash

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
            if k isnt "hostid"
              console.log character.name+": "+k+" - "+v+" -> "+headerData[k]
            changed = true
        if changed
          Characters.update({_id: character._id}, headerData)

String::hashCode = ->
  hash = 0
  i = undefined
  char = undefined
  return hash  if @length is 0
  i = 0
  l = @length

  while i < l
    char = @charCodeAt(i)
    hash = ((hash << 5) - hash) + char
    hash |= 0 # Convert to 32bit integer
    i++
  hash
