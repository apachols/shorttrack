class Routes
  constructor: (@app) ->
    modules = [
      'register'
      'admin'
      'login'
      'profile'
      'main'
    ]

    require("./#{m}") @app for m in modules

module.exports = (app) -> new Routes app
