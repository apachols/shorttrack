User = require '../models/user'
Meetup = require '../models/meetup'
Profile = require '../models/profile'
Question = require '../models/question'
Gender = require '../models/gender'

auth = require '../helpers/authenticator'

class Api
  constructor: (@app) ->

    @app.get '/api/test', @test

    @app.get '/api/profile', auth.user, @getprofile

    @app.post '/api/profile', auth.user, @updateprofile

    @app.get '/api/user', @getusers

    @app.get '/api/question/new', @createquestion
    @app.get '/api/question', @getquestions
    @app.post '/api/question/:_id', @updatequestion
    @app.delete '/api/question/:id', @deletequestion

    @app.get '/api/gender/new', @creategender
    @app.get '/api/gender', @getgenders
    @app.post '/api/gender/:_id', @updategender
    @app.delete '/api/gender/:id', @deletegender

  getprofile: (req,res,next) ->
    email = req.user.email
    req.user.profile.pop() or profile = new Profile age: seeking: [20,40]
    res.json {email, profile}

  updateprofile: (req,res,next) ->
    console.log req.body
    req.user.profile = req.body

    req.user.save (err, p, n) ->
      if err then res.send err, 400
      else res.send 200

  #
  # test
  #
  test: (req, res, next) ->
    # res.json req.user._id
    q = new Question
    res.json q


  #
  # User
  #
  getusers: (req, res, next) ->
    User.find req.query, (err, docs) ->
      return res.send 500, err if err
      res.json docs

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
    Question.update {_id}, req.body, (err, success) ->
      return res.send 500, err if err
      res.send 200

  createquestion: (req, res, next) ->
    doc = new Question
    res.json doc

  getquestions: (req, res, next) ->
    Question.find req.query, (err, docs) ->
      return res.send 500, err if err
      res.json docs
      console.log docs

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
    Gender.update {_id}, req.body, (err, success) ->
      return res.send 500, err if err
      res.send 200

  creategender: (req, res, next) ->
    console.log req.body
    Gender.create req.body, (err, doc) ->
      return res.send 500, err if err
      res.json {doc}

  getgenders: (req, res, next) ->
    Gender.find req.query, (err, docs) ->
      return res.send 500, err if err
      res.json docs


module.exports = (app) -> new Api app