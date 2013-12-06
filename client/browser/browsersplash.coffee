Template.browserSplash.rendered = ->
  $("#slider").cycle
    fx: "scrollVert"
    timeout: 3000
    speed: 300
    slides: ".slide"

justRegistered = false
Template.browserSplash.events
  'click #register': (e,t)->
    password = t.find('#password').value
    username = t.find('#username').value
    justRegistered = true
    Accounts.createUser {username: username, password : password}, (err)->
      justRegistered = false
      if err?
        $.pnotify
          title: "Registration Failed"
          text: err
          delay: 3000
          closer: false
          sticker: false
          type: "error"
      else
        $.pnotify
          title: "Success"
          text: "Welcome, "+username+"!"
          type: "success"
          delay: 5000
          closer: false
          sticker: false
  'submit #login-form': (e,t)->
    e.preventDefault()
    if justRegistered
      return
    username = t.find('#username').value
    password = t.find('#password').value
    Meteor.loginWithPassword username, password, (err)->
      if err?
        $.pnotify
          title: 'Login Failed'
          text: 'Login failed, please try again.'
          type: 'error'
          sticker: false
          delay: 3000
          closer: false
      else
        $.pnotify
          title: "Login Success"
          text: "Welcome, "+username+"!"
          type: "success"
          delay: 5000
          closer: false
          sticker: false
