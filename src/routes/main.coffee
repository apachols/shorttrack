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
    @app.get '/logout', @logout

    # Index
    @app.get '/', @index

  index: (req, res) -> res.render 'index'
  logout: (req, res) -> req.logout(); res.redirect '/'

module.exports = (app) -> new Main app
