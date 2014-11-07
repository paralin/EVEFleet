Meteor.publish "fleet", ->
    #support just browser for now
    Fleets.find
        active: true
        fcuser: @userId

Meteor.publish "trust", (hostHash)->
    check hostHash, String
    TrustStatus.find({ident: hostHash})

Meteor.publish "characters", (hostHash)->
    console.log "characters #{hostHash}"
    check hostHash, String
    Characters.find({hostid: hostHash})
