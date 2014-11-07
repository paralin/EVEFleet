@Characters = new Meteor.Collection "characters"

CharacterSchema = new SimpleSchema
    charId:
        type: String
        index: true
    name:
        type: String
    system:
        type: String
    systemid:
        type: Number
    stationname:
        type: String
    stationid:
        type: Number
    corpname:
        type: String
    corpid:
        type: Number
    alliancename:
        type: String
    allianceid:
        type: Number
    shipname:
        type: String
    shipid:
        type: Number
    shiptype:
        type: String
    shiptypeid:
        type: Number
    fleet:
        type: String
        index: true
    hostid:
        type: String
        index: true
    active:
        type: Boolean
        index: true
    lastActiveTime:
        type: Number

Characters.attachSchema CharacterSchema
