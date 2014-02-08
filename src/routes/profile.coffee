User = require '../models/User'
Gender = require '../models/Gender'

_ = require 'lodash'
tp = require 'tea-properties'
async = require 'async'

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

    async.parallel
      # easy mode future proof.
      # questions, events, whatever else we want goes here.
      genders: (cb) -> Gender.find {}, cb
    , (err, results) ->
      {genders} = results
      res.render 'profile', {user, genders}

  update: (req, res) ->
    {name, value} = req.body
    tp.set req.user.profile[0], name, value

    req.user.save (err) ->
      if err then res.send err, 400
      else res.send 200

module.exports = (app) -> new Profile app
