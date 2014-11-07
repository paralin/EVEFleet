Meteor.publish "fleet", ->
    #support just browser for now
    Fleets.find
        active: true
        fcuser: @userId

