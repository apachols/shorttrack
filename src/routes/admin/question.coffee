QuestionModel = require '../../models/question'
util = require 'util'

# routes for /admin/question/*
class Question
  constructor: (@app) ->
    @locals =
      brand: 'Edit Question'

    @app.get '/admin/question/:_id', @get

  # display a single question for editing
  get: (req, res) ->
    {_id} = req.params

    QuestionModel.findOne { _id }, (err, question) ->
      if question
        res.render 'admin/question', {question}

      else
        req.flash 'error', 'Question not found: ' + id
        res.redirect '/admin'

module.exports = (app) -> new Question app
