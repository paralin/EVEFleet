blankId = 9072099
Template.fleetMemberDetail.selChar= ->
  char = Session.get "selectedChar"
  char = Characters.findOne({_id: char._id})
  return blankId if !char?
  return char
Template.fleetMemberDetail.hasChar = ->
  char = Session.get "selectedChar"
  if !char?
    return false
  if !char.active
    Session.set "selectedChar", null
    return false
  char
Template.fleetMemberDetail.events
  'click .panelCloseBtn': ->
    Session.set "selectedChar", null
