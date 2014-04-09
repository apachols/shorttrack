MeetupModel = require '../models/meetup'
Matcher     = require '../lib/Matcher'
Scheduler   = require '../lib/Scheduler'

{inspect}   = require 'util'
{basename}  = require 'path'
_           = require 'lodash'

class Meetup
  constructor: (@app) ->

    @app.get  '/meetups/add', @authAdmin, @add
    @app.post '/meetups/create', @authAdmin, @create

    @app.get  '/meetup/:name/edit', @auth, @edit
    @app.post '/meetup/:name/update', @auth, @update

    @app.get  '/meetup/:name/register', @auth, @register
    @app.get  '/meetup/:name/unregister', @auth, @unregister

    @app.get  '/meetup/:name/schedules', @authAdmin, @schedules
    @app.get  '/meetup/:name/generate', @authAdmin, @generate

    @app.get  '/meetup/:name/schedule/:user', @authAdmin, @name

    @app.get  '/meetups', @authAdmin, @index
    @app.get  '/meetup/:name', @auth, @name

    @app.locals
      dateformat: 'mm/dd/yyyy'
      timeformat: 'hh:mm TT'

  authAdmin: (req, res, next) ->
    authenticated = req.isAuthenticated() and req.user?.admin
    return res.send 401, 'boo-urns' unless authenticated
    next()

  auth: (req, res, next) ->
    return res.send 401, 'boo-urns' unless req.isAuthenticated()
    next()

  index: (req, res) ->
    MeetupModel.find {}, (err, meetups) ->
      res.send 200, {meetups}

  add: (req, res) ->
    res.render 'meetups/add', {schema: MeetupModel.schema}

  create: (req, res) ->
    meetup = new MeetupModel req.body
    meetup.save (err, m) ->
      if err then res.send err, 400
      else res.redirect "/meetup/#{m.name}"

  edit: (req, res) =>
    {params: {name, user}, route: {path}} = req
    user ?= req.user?.email

    MeetupModel.findOne {name}, (err, meetup) =>
      done = (matches = {}) ->
        res.render "meetups/edit", {meetup, matches}

      return res.send 404, err if err

      @app.locals.registered = meetup.isRegistered user
      do done

  name: (req, res) =>
    {params: {name, user}, route: {path}} = req

    if user
      email = user
    else
      email = req.user?.email

    allowed = @app.locals.allowed = !!email

    MeetupModel.findOne {name}, (err, meetup) =>
      done = (matches = {}) ->

        # preprocess matches for display as schedule
        rounds = []

        for match in matches

          if email is match.user1.email
            match.partner = match.user2
          else
            match.partner = match.user1

          match.vote = req.user.relation match.partner.email
          rounds[match.round - 1] = match

        for round, i in rounds
          rounds[i] = {round:i+1, seat:'-'} unless round

        # res.send 200
        res.render "meetups/main", {meetup, rounds}

      return res.send 404, err if err
      registered = @app.locals.registered = meetup.isRegistered email

      if allowed and registered
        meetup.getScheduleUser email, done
      else
        do done

  buildRadioToggle: (array, vote) ->
    {key: n, vote: n is vote} for n in array

  stripView: (path) -> "#{basename path}".replace /\:/, ''

  register: (args...) => @unregister args...
  unregister: (req, res) =>
    {user, params: {name}, route: {path}} = req

    data = {registered: user.email}

    switch @stripView path
      when 'register' then query = {$push: data}
      when 'unregister' then query = {$pull: data}

    MeetupModel.findOneAndUpdate {name}
    , query
    , (err, meetup) ->
      meetup.registered = _.uniq meetup.registered
      meetup.save()
      res.redirect "/meetup/#{name}"

  schedules: (req, res) ->
    {name} = req.params
    MeetupModel.findOne {name}, (err, meetup) ->
      meetup.getScheduleAll (matches) ->
        res.render 'meetups/schedules', {matches, meetup}

  generate: (req, res) ->
    {name} = req.params

    MeetupModel.findOne {name}, (err, meetup) ->
      m = new Matcher meetup
      s = new Scheduler meetup

      m.execute (err, matches) ->
        console.error err if err
        console.log 'Created ' + matches.length + ' matches'

        meetup.matches = s.executeGreedyStrategy matches, 10
        meetup.save (err) ->
          console.log err if err
          res.redirect "/meetup/#{name}"

  update: (req, res) ->
    {name} = req.params

    MeetupModel.findOneAndUpdate {name}, {$set: req.body}
    , (err, meetup) ->
      unless err
        meetup.save()
        res.redirect "/meetup/#{meetup.name}"
      else
        res.send err, 400

module.exports = (app) -> new Meetup app
