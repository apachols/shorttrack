class Routes
  constructor: (@app) ->
    modules = [
      'register'
      'admin'
      'login'
      'profile'
    ]

    @app.get '*', (req, res, next) ->
      res.locals {
        brand: 'Homepage'
        my: req.user
      }
      next()

    require("./#{m}") @app for m in modules

    #Logout
    @app.get '/logout', (req, res) ->
      req.logout(); res.redirect '/'

    # Index needs to be last!
    @app.get '/', (req, res) ->
      res.render 'index'

module.exports = (app) -> new Routes app
