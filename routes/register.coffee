User = require '../models/User'

class Register
  constructor: ->
    app.get '/register', @get
    app.post '/register', @post

  get: (req, res) ->
    res.render 'register', {
      brand: 'Register'
      username: ''
    }

  post: (req, res) ->
    user = new User {
      username: req.body.username
    }

    User.register user, req.body.password, (err) ->
      if err then res.render 'register', {
        username: req.body.username
        error: err.message ? "Generroric"
      }

      res.redirect '/'

module.exports = new Register
