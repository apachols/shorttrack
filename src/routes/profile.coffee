User = require '../models/User'
Gender = require '../models/Gender'
ProfileModel = require '../models/Profile'

_ = require 'lodash'
tp = require 'tea-properties'
async = require 'async'
util = require 'util'

class Profile
  constructor: (@app) ->
    @app.all /^\/profile/, @auth, @setup

    @app.get '/profile/like/:email', @like
    @app.get '/profile/unlike/:email', @unlike

    @app.get '/profile', @get

    @app.post '/profile/update', @update

  setup: (req, res, next) ->
    res.locals { brand: 'Profile' }
    next()

  auth: (req, res, next) ->
    return res.send 401, 'boo-urns' unless req.isAuthenticated()
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

  like: (req, res) ->
    {email} = req.params

    index = (_.pluck req.user.relations, 'email').indexOf email
    if -1 isnt index
      req.user.relations[index].status = 'PLZ'
      req.user.save (err, thing) ->
        if err then res.send err, 400
        else res.send 200, 'updated'
    else
      User.findOneAndUpdate {email: req.user.email},
        $push:
          relations:
            email: email
            status: 'PLZ'
            date: new Date()
            notify: 0
      , (err, user) ->
        console.log util.inspect user
        if err then res.send err, 400
        else res.send 200, 'inserted'

  unlike: (req, res) ->
    {email} = req.params

    index = (_.pluck req.user.relations, 'email').indexOf email
    if -1 isnt index
      req.user.relations[index].status = 'KTHXBAI'
      req.user.save (err, thing) ->
        if err then res.send err, 400
        else res.send 200, 'updated'
    else
      User.findOneAndUpdate {email: req.user.email},
        $push:
          relations:
            email: email
            status: 'KTHXBAI'
            date: new Date()
            notify: 0
      , (err, user) ->
        console.log util.inspect user
        if err then res.send err, 400
        else res.send 200, 'inserted'

  update: (req, res) ->
    {user, name, value} = req.body

    p = req.user.profile.pop() or new ProfileModel

    tp.set p, name, value
    req.user.profile.push p

    req.user.save (err, p, n) ->
      if err then res.send err, 400
      else res.send 200

module.exports = (app) -> new Profile app
