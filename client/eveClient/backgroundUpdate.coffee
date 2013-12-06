Meteor.startup ->
  if not @eveClient
    return
  
  pathArray = window.location.href.split '/'
  webAddress = pathArray[0]+"//"+pathArray[2]+"/"
  
  Session.set("hostHash", Random.id())
  updateRequest = ()->
    HTTP.get webAddress+"background/update", {headers: {ident: Session.get("hostHash")}}, (err, res)->
      if err?
        console.log "Error trying to update the server with our status, "+err
        return
      trustStatus = TrustStatus.findOne({ident: Session.get("hostHash")})
      if Session.get("hasTrust") isnt trustStatus.status
        Session.set("hasTrust", trustStatus.status)  #  Session.set("hostHash", hostHash)
  setInterval(updateRequest, 3000)
  updateRequest()

