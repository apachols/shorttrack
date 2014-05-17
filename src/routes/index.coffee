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
    'schedule'
  ]
  require("./#{r}") app for r in routes
