meetupModel = require '../models/meetup'
_ = require 'lodash'
{inspect} = require 'util'

class Meetup
  constructor: (@app) ->
    @app.get  '/meetups', @index

    @app.get  '/meetups/add', @add
    @app.post '/meetups/create', @create

    @app.get  '/meetup/:name', @get
    @app.get  '/meetup/:name/:action', @action

  index: (req, res) ->
    meetupModel.find {}, (err, meetups) ->
      res.send 200, {meetups}

  add: (req, res) ->
    res.render 'meetups/add', {schema: meetupModel.schema}

  create: (req, res) ->
    # Meetup.create
    #   name: 'String'
    #   date: new Date()
    #   cap: 75
    #   time: [ new Date() ]
    #   registration: [ new Date() ]
    #   description: 'String'
    #   location: 'String'
    #   registered: [ 'String' ]

    meetup = new meetupModel req.body
    meetup.save (err, m) ->
      if err then res.send err, 400
      else res.redirect "/meetup/#{m.name}"

  get: (req, res) ->
    {name} = req.params
    meetupModel.findOne {name}, (err, meetup) ->
      res.send 200, {meetup}

  action: (req, res) ->
    {user, params: {name, action}} = req

    data = {registered: user.email}

    switch action
      when 'register' then query = {$push: data}
      when 'unregister' then query = {$pull: data}
      else res.send 404; return

    meetupModel.findOneAndUpdate {name}
    , query
    , (err, meetup) ->
      meetup.registered = _.uniq meetup.registered
      meetup.save()
      res.redirect "/meetup/#{name}"

module.exports = (app) -> new Meetup app
