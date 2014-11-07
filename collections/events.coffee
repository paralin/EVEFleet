@Events = new Meteor.Collection "events"

EventsSchema = new SimpleSchema
    fleet:
        type: String
        index: true
    time:
        type: Number
    message:
        type: String

Events.attachSchema EventsSchema
