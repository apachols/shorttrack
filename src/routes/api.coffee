User = require '../models/user'
Meetup = require '../models/meetup'
Matcher = require '../lib/matcher'
Scheduler = require '../lib/scheduler'
Profile = require '../models/profile'
Question = require '../models/question'
Gender = require '../models/gender'
mongoose = require 'mongoose'
_ = require 'lodash'

auth = require '../helpers/authenticator'
util = require 'util'

class Api
  constructor: (@app) ->

    @app.post '/api/test/:_id', @test

    @app.get '/api/userschedule/:_id', auth.user, @userschedule

    @app.get '/api/generate/:_id/:pool?', auth.user, @generate

    @app.get '/api/fullschedule/:_id', auth.admin, @fullschedule
    @app.get '/api/userlist/:id', auth.admin, @getuserlist

    @app.get '/api/profile', auth.user, @getprofile
    @app.post '/api/profile', auth.user, @updateprofile

    @app.get '/api/meetup/:_id', @getmeetup
    @app.get '/api/register/:_id', auth.user, @register
    @app.get '/api/unregister/:_id', auth.user, @unregister

    @app.get '/api/user', @getusers

    @app.get '/api/question/new', @createquestion
    @app.get '/api/question', @getquestions
    @app.post '/api/question/:_id', @updatequestion
    @app.delete '/api/question/:id', @deletequestion

    @app.get '/api/gender/new', @creategender
    @app.get '/api/gender', @getgenders
    @app.post '/api/gender/:_id', @updategender
    @app.delete '/api/gender/:id', @deletegender

  register: (req, res) ->
    {_id} = req.params
    Meetup.findOne {_id}, (err, meetup) ->
      return res.send 500, err if err
      for regid in meetup.registered
        if regid.toString() == req.user._id.toString()
          found = true
      if !found
        meetup.registered.push req.user._id
        meetup.save (err, thing)->
          return res.send 500, err if err
          res.send 200, thing
      else
        res.send 400, 'Already registered'

  unregister: (req, res) ->
    {_id} = req.params
    Meetup.findOne {_id}, (err, meetup) ->
      return res.send 500, err if err
      for regid, ii in meetup.registered
        if regid.toString() == req.user._id.toString()
          meetup.registered.splice ii, 1
          return meetup.save (err, thing)->
            return res.send 500, err if err
            res.send 200, thing
      res.send 400, 'Not Registered'

  getmeetup: (req, res)->
    {_id} = req.params
    Meetup.findOne {_id}, (err, meetup) ->
      registered = false
      if req.isAuthenticated()
        registered = meetup.isRegistered req.user._id.toString()
      res.json {meetup, registered}

  generate: (req, res) ->
    {_id, pool} = req.params

    # We only have 2 pools of users so far.
    pool = 'registered' unless pool is 'paid'

    Meetup.findOne {_id}, (err, meetup) ->
      m = new Matcher meetup
      s = new Scheduler meetup

      m.execute pool, (err, matches) ->
        console.error err if err
        console.log 'Created ' + matches.length + ' matches'

        meetup.matches = s.executeGreedyStrategy matches, meetup.cap
        meetup.save (err) ->
          res.send 500, err if err
          res.send 200

  userschedule: (req, res) ->
    {_id} = req.params

    Meetup.findOne { _id }, (err, meetup) ->
      meetup.getScheduleUser req.user._id.toString(), (matches) ->
        rounds = []

        for match in matches
          r = match.toObject()

          # if the logged in user is the person whose schedule we are fetching,
          # set the 'partner' key on each round to be the other person, whether
          # the other person happens to be user1 or user2 in the match
          if req.user._id.toString() is r.user1.userid
            r.partner = r.user2
          else
            r.partner = r.user1

          r.vote = req.user.relation r.partner.userid

          rounds[r.round - 1] = r

        # After all the rounds have had their partners and votes fetched,
        # fill in the gaps with break rounds (seat === '-')
        for round, i in rounds
          R = {round:i+1, seat:'-', break:true}
          rounds[i] = R unless round

        res.json {rounds}

  # Display the schedule for a meetup
  fullschedule: (req, res) ->
    {_id} = req.params
    Meetup.findOne {_id}, (err, meetup) ->
      meetup.getScheduleAll (dates) ->
        res.json {dates}

  getuserlist: (req,res,next) ->
    {id} = req.params
    Meetup.findOne({_id: id})
      .populate('registered', 'email profile')
      .exec (err, meetup) ->
        return res.send 500, err if err
        console.log meetup
        {registered, paid} = meetup
        res.json {registered, paid}

  getprofile: (req,res,next) ->
    email = req.user.email
    profile = req.user.profile.pop() or new Profile age: seeking: [20,40]
    res.json {email, profile}

  updateprofile: (req,res,next) ->
    req.user.profile = req.body

    req.user.save (err, p, n) ->
      if err then res.send err, 400
      else res.send 200

  #
  # test
  #
  test: (req, res, next) ->
    {_id} = req.params
    delete req.body.__v
    delete req.body._id
    Gender.update {_id}, req.body, (err, success) ->
      return res.send 500, err if err
      res.send 200

  #
  # User
  #
  getusers: (req, res, next) ->
    User.find req.query, (err, docs) ->
      return res.send 500, err if err
      res.json {docs}

  #
  # Question
  #
  deletequestion: (req, res, next) ->
    {id} = req.params
    Question.findByIdAndRemove id, (err, doc) ->
      return res.send 500, err if err
      res.json {doc}

  updatequestion: (req, res, next) ->
    {_id} = req.params
    delete req.body.__v
    delete req.body._id
    Question.update {_id}, req.body, (err, success) ->
      return res.send 500, err if err
      res.send 200

  createquestion: (req, res, next) ->
    doc = new Question
    doc.save ->
      res.json doc

  getquestions: (req, res, next) ->
    Question.find req.query, (err, docs) ->
      return res.send 500, err if err
      res.json {docs}

  #
  # Gender
  #
  deletegender: (req, res, next) ->
    {id} = req.params
    Gender.findByIdAndRemove id, (err, doc) ->
      return res.send 500, err if err
      res.json {doc}

  updategender: (req, res, next) ->
    {_id} = req.params
    delete req.body.__v
    delete req.body._id
    Gender.update {_id}, req.body, (err, success) ->
      return res.send 500, err if err
      res.send 200

  creategender: (req, res, next) ->
    doc = new Gender
    doc.save ->
      res.json doc

  getgenders: (req, res, next) ->
    Gender.find req.query, (err, docs) ->
      return res.send 500, err if err
      res.json {docs}


module.exports = (app) -> new Api app