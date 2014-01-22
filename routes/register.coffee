User = require '../models/User'

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
      if err then res.render 'register', {
        email: req.body.email
        error: err.message ? "Generroric"
      }

      res.redirect '/'

module.exports = (app) -> new Register app
