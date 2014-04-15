Meetup = require '../models/meetup'

Question = require '../models/question'

auth = require '../helpers/authenticator'

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
    @app.put '/api/question/:id', auth.admin, @updatequestion
    @app.delete '/api/question/:id', @deletequestion

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
