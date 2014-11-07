joinInstructions = false
animatedIn = false
Session.set("startMenuFlipped", false)
Session.set "showFleetForm", false
Tracker.autorun ->
  route = Router.current()
  if !route?
    return
  if route.template isnt "home"
    animatedIn = false
Template.browserHome.rendered = ->
  if !animatedIn
    $("#startmenu").css({top: '-254px'}).transition({top:'100px'}, 900, 'ease')
    $("#createFleetForm").hide()
    animatedIn = true
  else
    $("#startmenu").css({top: '100px'})
Template.browserHome.showFleetForm = ->
  Session.get "showFleetForm"
Template.fleetSetupForm.rendered = ->
  $("#createFleetForm").hide().fadeIn(450)
  $("#startmenu").stop().css({height: '400px'})
Template.browserHome.events
  'click .flipbtn': ->
    $("#startmenu").stop().transition({perspective: '500px', rotateY: (if joinInstructions then '0deg' else '-180deg')
    }, 600)
    $(".panel-body").transition({opacity: 0}, 290, 'linear', ()->
      Session.set("startMenuFlipped", joinInstructions)
      $(".panel-body").transition({opacity: 100}, 300, 'linear')
    )
    $(".panel-title").transition({opacity: (if joinInstructions then 100 else 0)})
    joinInstructions = !joinInstructions
  'click #createFleetBtn': (e)->
    e.preventDefault()
    $("#startmenu").transition({height: '400px'}, 900, 'ease', ->
      Session.set "showFleetForm", true
    )
    $("#startOptions").hide(450, ->
    )
  'click #finalizeFleetBtn': (e)->
    e.preventDefault()
    fleetName = $("#fleetName").val()
    motd = $("#motd").val()
    console.log "name: "+fleetName+" motd: "+motd
    Meteor.call "createFleet", fleetName, motd, (err, res)->
      if err?
        $.pnotify
          title: "Couldn't Create Fleet"
          text: err.reason
          type: 'error'
          sticker: false
      else
        $.pnotify
          title: "Fleet Created"
          text: "Welcome to the FC interface!"
          type: "success"
          sticker: false
        Session.set "startMenuFlipped", false
Template.browserHome.menuFlipped = ->
  Session.get "startMenuFlipped"
Template.browserHome.baseUrl = ->
  pathArray = window.location.href.split '/'
  pathArray[0]+"//"+pathArray[2]+"/"
