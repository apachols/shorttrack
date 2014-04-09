User = require('../models/user')
Profile = require('../models/profile')

class Register
  constructor: (@app) ->
    @app.get '/register', @get
    @app.post '/register', @post

  get: (req, res) ->
    res.render 'register', {
      brand: 'Register'
      email: ''
    }

  post: (req, res) ->
    user = new User {
      email: req.body.email
    }

    User.register user, req.body.password, (err) ->
      if err
        console.error(err)
        return res.render 'register', {
          email: req.body.email
          errormessage: err.message ? "Unknown error occurred"
        }

      res.redirect '/login'

module.exports = (app) -> new Register app
