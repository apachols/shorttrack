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
    @app.post '/api/question/:_id', @updatequestion
    @app.post '/api/question', @createquestion
    @app.delete '/api/question/:id', @deletequestion

    @app.get '/api/gender', @getgenders
    @app.post '/api/gender/:_id', @updategender
    @app.post '/api/gender', @creategender
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
    {_id} = req.params
    Question.update {_id}, req.body, (err, success) ->
      return res.send 500, err if err
      res.send 200

  createquestion: (req, res, next) ->
    Question.create req.body, (err, doc) ->
      return res.send 500, err if err
      res.json {doc}

  getquestions: (req, res, next) ->
    Question.find req.query, (err, docs) ->
      return res.send 500, err if err
      res.json docs
      console.log docs

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