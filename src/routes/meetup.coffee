meetupModel = require '../models/meetup'
{inspect} = require 'util'
p = require 'path'
_ = require 'lodash'

class Meetup
  constructor: (@app) ->

    @app.get  '/meetups/add', @add
    @app.post '/meetups/create', @create

    @app.get  '/meetup/:name/edit', @edit
    @app.post '/meetup/:name/update', @update

    @app.get  '/meetup/:name/register', @register
    @app.get  '/meetup/:name/unregister', @unregister

    @app.get  '/meetups', @index
    @app.get  '/meetup/:name', @name

    @app.locals
      dateformat: 'mm/dd/yyyy'
      timeformat: 'hh:mm TT'

  index: (req, res) ->
    meetupModel.find {}, (err, meetups) ->
      res.send 200, {meetups}

  add: (req, res) ->
    res.render 'meetups/add', {schema: meetupModel.schema}

  create: (req, res) ->
    meetup = new meetupModel req.body
    meetup.save (err, m) ->
      if err then res.send err, 400
      else res.redirect "/meetup/#{m.name}"

  edit: (args...) => @name args...
  name: (req, res) =>
    {params: {name}, route: {path}} = req
    meetupModel.findOne {name}, (err, meetup) =>
      view = @stripView path
      res.render "meetups/#{view}", {meetup}

  stripView: (path) -> "#{p.basename path}".replace /\:/, ''

  register: (args...) => @unregister args...
  unregister: (req, res) =>
    {user, params: {name}, route: {path}} = req

    data = {registered: user.email}

    switch @stripView path
      when 'register' then query = {$push: data}
      when 'unregister' then query = {$pull: data}

    meetupModel.findOneAndUpdate {name}
    , query
    , (err, meetup) ->
      meetup.registered = _.uniq meetup.registered
      meetup.save()
      res.redirect "/meetup/#{name}"

  update: (req, res) =>
    {name} = req.params

    meetupModel.findOneAndUpdate {name}
    , {$set: req.body}
    , (err, meetup) ->
      unless err
        meetup.save()
        res.redirect "/meetup/#{meetup.name}"
      else
        console.log err


module.exports = (app) -> new Meetup app
