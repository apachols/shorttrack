MeetupModel = require '../models/meetup'
Matcher     = require '../lib/Matcher'
Scheduler   = require '../lib/Scheduler'

{inspect}   = require 'util'
{basename}  = require 'path'
_           = require 'lodash'

class Meetup
  constructor: (@app) ->

    @app.get  '/meetups/add', @add
    @app.post '/meetups/create', @create

    @app.get  '/meetup/:name/edit', @edit
    @app.post '/meetup/:name/update', @update

    @app.get  '/meetup/:name/register', @register
    @app.get  '/meetup/:name/unregister', @unregister

    @app.get  '/meetup/:name/schedules', @schedules
    @app.get  '/meetup/:name/generate', @generate

    @app.get  '/meetup/:name/schedule/:user', @name

    @app.get  '/meetups', @index
    @app.get  '/meetup/:name', @name

    @app.locals
      dateformat: 'mm/dd/yyyy'
      timeformat: 'hh:mm TT'

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
      done = (matches = {}) =>

        # preprocess matches for display as schedule
        rounds = []

        for match in matches

          if email is match.user1.email
            match.partner = match.user2
          else
            match.partner = match.user1

          vote = req.user.relation match.partner.email

          match.votes = @buildRadios ['PLZ', 'MEH', 'BAI'], vote

          rounds[match.round-1] = match

        for round, i in rounds
          rounds[i] = {round:i+1, seat:'-'} unless round

        res.render "meetups/main", {meetup, rounds}

      return res.send 404, err if err
      registered = @app.locals.registered = meetup.isRegistered email

      if allowed and registered
        meetup.getScheduleUser email, done
      else
        do done

  buildRadios: (array, vote) ->
    for value in array
      checked: vote is value
      value: value

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
