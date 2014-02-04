User = require('../models/User')

class Profile
  constructor: (@app) ->
    @app.all /^\/profile/, @auth

    @app.get '/profile', @get

    @app.post '/profile/update', @update

  auth: (req, res, next) ->
    return res.send 'boo-urns', 401 unless req.isAuthenticated()
    next()

  get: (req, res) ->
    res.render 'profile', {
      brand: 'Profile'
      user: req.user
    }

  update: (req, res) ->
    {pk, name, value} = req.body
    return res.send 'Invalid update request', 403 unless pk == req.user.email

    console.log 'UPDATE'

    findSpec =
      email: pk

    User.findOne findSpec, (err,user) ->
      if err then res.send 'DB error', 500

      if user == null then res.send 'Invalid user', 400

      try
        user.profile[0][name] = value
        user.save()
        res.send 200

      catch e
        console.error e
        res.send 'Invalid update request', 400

module.exports = (app) -> new Profile app
