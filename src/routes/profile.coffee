User = require '../models/user'
Gender = require '../models/gender'
ProfileModel = require '../models/profile'
auth = require '../helpers/authenticator'

_ = require 'lodash'
tp = require 'tea-properties'
async = require 'async'
util = require 'util'

class Profile
  constructor: (@app) ->
    @app.all /^\/profile/, auth.user, @setup

    @app.post '/profile/vote/:_id/:vote', auth.user, @vote

    @app.post '/profile/update', auth.user, @update

    @app.get '/profile', @get

  setup: (req, res, next) ->
    res.locals { brand: 'Profile' }
    next()

  get: (req, res) ->
    {user} = req
    res.render 'profile', {user}

  vote: (req, res) ->
    {_id, vote} = req.params

    req.user.relate _id, vote, (err, wtvz) ->
      if err then res.send 500
      else res.send 200

  update: (req, res) ->
    {user, name, value} = req.body

    p = req.user.profile.pop() or new ProfileModel

    tp.set p, name, value
    req.user.profile.push p

    req.user.save (err, p, n) ->
      if err then res.send err, 400
      else res.send 200

module.exports = (app) -> new Profile app
