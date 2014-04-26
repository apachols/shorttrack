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
    res.render 'admin/question', {_id}

module.exports = (app) -> new Question app
