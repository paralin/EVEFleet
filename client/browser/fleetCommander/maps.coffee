Deps.autorun ->
  route = Router.current()
  if !route?
    return
  if route.template isnt "fleetCommander"
    return
  region = Session.get("currentRegion")
  if !region?
    region = "Everyshore"
  url = "/svg/"+region.replace(" ", "_")+".svg"
  console.log "Rendering map: "+url
  $("#fcMiddle").load(url)
