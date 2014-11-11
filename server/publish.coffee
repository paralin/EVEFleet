Meteor.publishComposite "igbdata", (hostHash)->
  find: ->
    TrustStatus.find
      ident: hostHash
  children: [
      {
        find: (trust)->
          return if !(trust? and trust.status)
          Characters.find {hostid: hostHash}, {limit: 1, fields: {active: 0}}
      }
      {
        find: (trust)->
          return if !(trust? and trust.status)
          Characters.find {hostid: hostHash}, {limit: 1, fields: {active: 0}}
        children: [
          {
            find: (character, trust)->
              return if !(character? and character.fleet?)
              Fleets.find {_id: character.fleet}, {limit: 1}
          }
        ]
      }
  ]

Meteor.publishComposite "browserdata", ->
  find: ->
    return if !@userId?
    Fleets.find(
      active: true
      fcuser: @userId
    ,
      limit: 1
    )
  children: [
    {
      find: (fleet)->
        Characters.find
          active: true
          fleet: fleet._id
    }
    {
      find: (fleet)->
        Events.find
          fleet: fleet._id
    }
  ]
