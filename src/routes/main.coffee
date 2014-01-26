class Main
  constructor: (@app) ->

    # Set up some globals for all the pages.
    @app.get '*', (req, res, next) ->
      res.locals {
        brand: 'Homepage'
        my: req.user
      }
      next()

    # Logout
    @app.get '/logout', (req, res) ->
      req.logout(); res.redirect '/'

    # Index
    @app.get '/', (req, res) ->
      res.render 'index'

module.exports = (app) -> new Main app
