User = require '../models/user'
Meetup = require '../models/meetup'
Question = require '../models/question'
Gender = require '../models/gender'

auth = require '../helpers/authenticator'

class Api
  constructor: (@app) ->

    @app.get '/api/test', @test

    @app.get '/api/user', @getusers

    @app.get '/api/question', @getquestions
    @app.post '/api/question', @createquestion
    @app.put '/api/question/:id', auth.admin, @updatequestion
    @app.delete '/api/question/:id', @deletequestion

    @app.get '/api/gender/:_id', @getgender
    @app.get '/api/gender', @getgenders
    @app.post '/api/gender/:_id', @updategender
    @app.delete '/api/gender/:id', @deletegender

  #
  # test
  #
  test: (req, res, next) ->
    User.find req.query, (err, docs) ->
      return res.send 500, err if err

      for doc in docs
        console.log doc.get "email"

      res.json docs

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
    {id} = req.params
    Question.findById id, (err, doc) ->
      return res.send 500, err if err
      doc.update req.body, (err, success) ->
        res.json {success}

  createquestion: (req, res, next) ->
    Question.create req.body, (err, doc) ->
      return res.send 500, err if err
      res.json {doc}

  getquestions: (req, res, next) ->
    Question.find req.query, (err, docs) ->
      return res.send 500, err if err
      res.json docs

  #
  # Genders
  #
  deletegender: (req, res, next) ->
    {id} = req.params
    Gender.findByIdAndRemove id, (err, doc) ->
      return res.send 500, err if err
      res.json {doc}

  updategender: (req, res, next) ->
    {_id} = req.params
    console.log req.body, _id
    Gender.update {_id}, req.body, (err, success, third) ->
      console.log "inside", err, success, third
      return res.send 500, err if err
      res.send 200

  creategender: (req, res, next) ->
    Gender.create req.body, (err, doc) ->
      return res.send 500, err if err
      res.json {doc}

  getgenders: (req, res, next) ->
    Gender.find req.query, (err, docs) ->
      return res.send 500, err if err
      res.json docs

  getgender: (req, res, next) ->
    {_id} = req.params
    Gender.findOne {_id}, (err, doc) ->
      return res.send 500, err if err
      res.json doc


module.exports = (app) -> new Api app