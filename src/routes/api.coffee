User = require '../models/user'
Meetup = require '../models/meetup'
Question = require '../models/question'

auth = require '../helpers/authenticator'

class Api
  constructor: (@app) ->

    @app.get '/api/user', @getusers

    @app.get '/api/question', @getquestions
    @app.post '/api/question', @createquestion
    @app.put '/api/question/:id', auth.admin, @updatequestion
    @app.delete '/api/question/:id', @deletequestion

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
      res.json {docs}

module.exports = (app) -> new Api app