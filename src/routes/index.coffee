module.exports = (app) ->
  routes = [
    'main'
    'register'
    'admin'
    'login'
    'profile'
    'meetup'
    'forgot'
    'api'
  ]
  require("./#{r}") app for r in routes
