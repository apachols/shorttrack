class Main
  constructor: (@app) ->

    # Set up some globals for all the pages.
    @app.get '*', @setup

    # Logout
    @app.get '/logout', @logout

    # Index
    @app.get '/', @index

  setup: (req, res, next) ->
    res.locals {
      my: req.user
      brand: 'Homepage'
    }
    next()

  index: (req, res) -> res.render 'index'
  logout: (req, res) -> req.logout(); res.redirect '/'

module.exports = (app) -> new Main app
