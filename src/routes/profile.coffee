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

    req.user.profile[0][name] = value
    req.user.save (err) ->
      if err then res.send 'Invalid update request', 400
      else res.send 200

module.exports = (app) -> new Profile app
