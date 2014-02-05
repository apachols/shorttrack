User = require '../models/User'
_ = require 'lodash'

class Profile
  constructor: (@app) ->
    @app.all /^\/profile/, @auth, @brand

    @app.get '/profile', @get

    @app.post '/profile/update', @update

  brand: (req, res, next) ->
    res.locals { brand: 'Profile' }
    next()

  auth: (req, res, next) ->
    return res.send 'boo-urns', 401 unless req.isAuthenticated()
    next()

  get: (req, res) ->
    {user} = req
    res.render 'profile', {user}

  update: (req, res) ->
    {name, value} = req.body
    {p: [profile]} = req.user

    if typeof value is 'object' then _.merge profile[name], value
    else profile[name] = value

    req.user.save (err) ->
      if err then res.send err, 400
      else res.send 200

module.exports = (app) -> new Profile app
