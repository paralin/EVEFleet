joinInstructions = false
animatedIn = false
Session.set("startMenuFlipped", false)
Template.browserHome.rendered = ->
  $("#startmenu").css({height: '235px'})
  if !animatedIn
    $("#startmenu").css({top: '-254px'}).transition({top:'100px'}, 900, 'ease')
    $("#createFleetForm").hide()
    animatedIn = true
  else
    $("#startmenu").css({top: '100px'})
Template.browserHome.events
  'click .flipbtn': ->
    $("#startmenu").stop().transition({rotateY: (if joinInstructions then '0deg' else '-180deg')
    }, 600)
    $(".panel-body").transition({opacity: 0}, 290, 'linear', ()->
      Session.set("startMenuFlipped", joinInstructions)
      $(".panel-body").transition({opacity: 100}, 300, 'linear')
    )
    $(".panel-title").transition({opacity: (if joinInstructions then 100 else 0)})
    joinInstructions = !joinInstructions
  'click #createFleetBtn': ->
    $("#startmenu").transition({height: '400px'}, 900, 'ease')
    $("#startOptions").fadeOut 450, ->
      $("#startOptions").hide()
      $("#createFleetForm").fadeIn(450)
Template.browserHome.menuFlipped = ->
  Session.get "startMenuFlipped"
Template.browserHome.baseUrl = ->
  pathArray = window.location.href.split '/'
  pathArray[0]+"//"+pathArray[2]+"/"
