pass = require 'passport'

class Login

  constructor: (@app) ->
    @app.get '/login', @get
    @app.post '/login', @auth

  get: (req, res) -> 
    res.render 'login', {
      brand: 'Login Form'
      my: req.user
    }

  auth: pass.authenticate 'local', {
    successRedirect: '/'
    failureFlash: true
    failureRedirect: '/login'
  }

module.exports = (app) -> new Login app
