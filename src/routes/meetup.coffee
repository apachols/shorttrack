meetupModel = require '../models/meetup'
_ = require 'lodash'

class Meetup
  constructor: (@app) ->
    @app.get '/meetup/:name', @get
    @app.get '/meetup/:name/:action', @action

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

    meetupModel.findOneAndUpdate {name}
    , query
    , (err, meetup) ->
      meetup.registered = _.uniq meetup.registered
      meetup.save()
      res.redirect "/meetup/#{name}"

module.exports = (app) -> new Meetup app
