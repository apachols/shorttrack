meetupModel = require '../models/meetup'

class Meetup
  constructor: (@app) ->
    @app.get '/meetup/:name', @get
    @app.get '/meetup/:name/register', @register
    @app.get '/meetup/:name/unregister', @unregister

  get: (req, res) ->
    {name} = req.params
    meetupModel.findOne {name}, (err, meetup) ->
      res.send 200, {meetup}

  register: (req, res) ->
    {user, params: {name}} = req
    meetupModel.findOneAndUpdate {name},
      $push: {registered: user.email}
    , (err, meetup) ->
      res.redirect "/meetup/#{name}"

  unregister: (req, res) ->
    {user, params: {name}} = req
    meetupModel.findOneAndUpdate {name},
      $pull: {registered: user.email}
    , (err, meetup) ->
      res.redirect "/meetup/#{name}"

module.exports = (app) -> new Meetup app
