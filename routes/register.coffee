User = require('../models/User')
Profile = require('../models/Profile')

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

      res.redirect '/'

module.exports = (app) -> new Register app
