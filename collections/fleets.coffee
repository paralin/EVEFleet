@Fleets = new Meteor.Collection "fleets"

FleetsSchema = new SimpleSchema
    name:
        type: String
    motd:
        type: String
    fcuser:
        type: String
        index: true
    active:
        type: Boolean

Fleets.attachSchema FleetsSchema
