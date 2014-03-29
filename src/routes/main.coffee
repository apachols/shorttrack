Meetup = require '../models/Meetup'

class Main
  constructor: (@app) ->

    # Set up some globals for all the pages.
    @app.get '*', @setup

    # Logout
    @app.get '/logout', @logout

    # Index
    @app.get '/', @index

  setup: (req, res, next) ->
    res.locals
      my: req.user
      brand: 'Homepage'
      path: req.path

    do next

  index: (req, res) ->
    Meetup.find {}, (err, meetups) ->
      return res.send 500, err if err
      res.render 'index', {meetups}

  logout: (req, res) -> req.logout(); res.redirect '/'

module.exports = (app) -> new Main app
