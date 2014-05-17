MeetupModel   = require '../models/meetup'
Matcher       = require '../lib/matcher'
Scheduler     = require '../lib/scheduler'
auth          = require '../helpers/authenticator'
mongoose      = require 'mongoose'


angularBridge = require 'angular-bridge'
{inspect}     = require 'util'
{basename}    = require 'path'
_             = require 'lodash'

class Meetup
  constructor: (@app) ->

    # @app.get  '/meetups/add', auth.admin, @add
    # @app.post '/meetups/create', auth.admin, @create

    # @app.get  '/meetup/:name/edit', auth.user, @edit
    # @app.post '/meetup/:name/update', auth.user, @update

    @app.get  '/meetup/:name/register', auth.user, @register
    @app.get  '/meetup/:name/unregister', auth.user, @unregister

    @app.get  '/meetup/:name/generate/:pool?', auth.admin, @generate

    # @app.get  '/meetup/:name/schedules', auth.admin, @schedules
    # @app.get  '/meetup/:name/schedule/:userid', auth.admin, @name

    # # @app.get  '/meetups', auth.admin, @index
    # @app.get  '/meetup/:name', @name


    @app.locals
      dateformat: 'mm/dd/yyyy'
      timeformat: 'hh:mm TT'

    # Reads are free
    # @app.post '/api2/meetups', auth.admin
    @app.put '/api2/meetups', auth.admin
    @app.delete '/api2/meetups', auth.admin

    urlPrefix = '/api2/'
    bridge = new angularBridge @app, {urlPrefix}
    bridge.addResource 'meetups', MeetupModel

  add: (req, res) ->
    res.render 'meetups/add', {schema: MeetupModel.schema}

  create: (req, res) ->
    meetup = new MeetupModel req.body
    meetup.save (err, m) ->
      if err then res.send err, 400
      else res.redirect "/meetup/#{m.name}"

  edit: (req, res) =>
    {params: {name, user}, route: {path}} = req

    userid = req.user?._id

    MeetupModel.findOne {name}, (err, meetup) =>
      done = (matches = {}) ->
        res.render "meetups/edit", {meetup, matches}

      return res.send 404, err if err

      @app.locals.registered = meetup.isRegistered userid
      do done

  name: (req, res) =>
    {params: {name, userid}, route: {path}} = req

    if userid
      userid = userid
    else
      userid = req.user?._id.toString()

    console.log userid

    allowed = @app.locals.allowed = !!userid

    MeetupModel.findOne {name}, (err, meetup) =>
      done = (matches = {}) ->

        # preprocess matches for display as schedule
        rounds = []

        for match in matches

          if userid is match.user1.userid
            match.partner = match.user2
          else
            match.partner = match.user1

          match.vote = req.user.relation match.partner.userid
          rounds[match.round - 1] = match

        for round, i in rounds
          rounds[i] = {round:i+1, seat:'-'} unless round

        # res.send 200
        res.render "meetups/main", {userid, meetup, rounds}

      return res.send 404, err if err
      registered = @app.locals.registered = meetup.isRegistered userid

      if allowed and registered
        meetup.getScheduleUser userid, done
      else
        do done

  buildRadioToggle: (array, vote) ->
    {key: n, vote: n is vote} for n in array

  stripView: (path) -> "#{basename path}".replace /\:/, ''

  register: (args...) => @unregister args...
  unregister: (req, res) =>
    {user, params: {name}, route: {path}} = req

    uid = mongoose.Types.ObjectId user._id.toString()
    data = { registered: uid }

    switch @stripView path
      when 'register' then query = {$push: data}
      when 'unregister' then query = {$pull: data}

    MeetupModel.findOneAndUpdate {name}
    , query
    , (err, meetup) ->
      meetup.registered = _.uniq meetup.registered
      meetup.save()
      res.redirect "/meetup/#{name}"

  # Display the schedule for a meetup
  schedules: (req, res) ->
    {name} = req.params
    MeetupModel.findOne {name}, (err, meetup) ->
      meetup.getScheduleAll (matches) ->
        res.render 'meetups/schedules', {matches, meetup}

  # Generate a schedule for a meetup.
  generate: (req, res) ->
    {name, pool} = req.params

    # We only have 2 pools of users so far.
    pool = 'registered' unless pool is 'paid'

    MeetupModel.findOne {name}, (err, meetup) ->
      m = new Matcher meetup
      s = new Scheduler meetup

      m.execute pool, (err, matches) ->
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
