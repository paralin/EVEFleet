Characters = new Meteor.Collection "characters"
PendingTrust = new Meteor.Collection "truststat"

#remove temp stuff on start
PendingTrust.remove({})

Meteor.publish "trust", ()->
  PendingTrust.find({})

Meteor.publish "characters", (hostHash)->
  Characters.find({hostid: hostHash})

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
          hostid: hostHash

      #find the character object
      character = Characters.findOne({charId: @request.headers["eve_charid"]})
      if !character?
        console.log "new character registered: "+@request.headers["eve_charname"]
        headerData._id = Characters.insert(headerData)
      else
        headerData._id = character._id
        changed = false
        #loop over keys, look for changes
        for k,v of character
          if headerData[k] isnt v && headerData[k]?
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
