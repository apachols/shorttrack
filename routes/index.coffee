class Routes
  constructor: (@app) ->
    require('./register') @app
    require('./admin') @app
    require('./login') @app

    #Logout
    @app.get '/logout', (req, res) ->
      req.logout()
      res.redirect '/'

    # Index needs to be last!
    @app.get '/', (req, res) ->
      res.locals =
        brand: 'Homepage'
        my: req.user

      res.render 'index'

module.exports = (app) -> new Routes app
