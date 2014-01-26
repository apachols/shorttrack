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

  index: (i, o) -> o.render 'index'
  logout: (i, o) -> i.logout(); o.redirect '/'

module.exports = (app) -> new Main app
