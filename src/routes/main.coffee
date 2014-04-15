Meetup = require '../models/meetup'

Question = require '../models/question'

class Main
  constructor: (@app) ->

    # Set up some globals for all the pages.
    @app.get '*', @setup

    # Logout
    @app.get '/logout', @logout

    # Index
    @app.get '/', @index

    # Index
    @app.get '/api/question', @getquestions
    @app.post '/api/question', @createquestion

  createquestion: (req, res, next) ->
    console.dir req
    q = new Question req.body
    q.save (err, newquestion) ->
      return res.send 500, err if err
      res.json {newquestion}

  getquestions: (req, res, next) ->
    Question.find {}, (err, questions) ->
      return res.send 500, err if err
      res.json {questions}

  setup: (req, res, next) ->
    res.locals
      my: req.user
      brand: 'Homepage'
      path: req.path

    do next

  index: (req, res) ->
    Meetup.find({}).sort({date: 1}).find (err, meetups) ->
      return res.send 500, err if err
      res.render 'index', {meetups}

  logout: (req, res) -> req.logout(); res.redirect '/'

module.exports = (app) -> new Main app
