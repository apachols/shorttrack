class Profile
  constructor: (@app) ->
    @app.get '/profile', @home

  home: (req, res) ->
    res.send 'hello moto'

module.exports = (app) -> new Profile app
