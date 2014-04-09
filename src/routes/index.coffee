class Routes
  constructor: (@app) ->
    modules = [
      'main'
      'register'
      'admin'
      'login'
      'profile'
      'meetup'
    ]

    require("./#{m}") @app for m in modules

module.exports = (app) -> new Routes app
