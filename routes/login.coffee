pass = require 'passport'

class Login

  @locals:
    brand: 'Login Form'

  constructor: ->
    app.get '/login', @get
    app.post '/login', @auth

  get: (req, res) -> 
    
    res.render 'login', {
      my: req.user
    }

  auth: pass.authenticate 'local', {
    successRedirect: '/'
    failureFlash: true
    failureRedirect: '/login'
  }

module.exports = new Login
