async = require 'async'
crypto = require 'crypto'
user = require '../models/user'

class Routes
  constructor: (@app) ->
    modules = [
      'main'
      'register'
      'admin'
      'login'
      'profile'
      'meetup'
      'api'
    ]

    require("./#{m}") @app for m in modules

    @app.get '/forgot', (req, res) ->
      res.send 'forgot\n'

    @app.post '/forgot', (req, res) ->
      async.waterfall [
        (done) ->
          crypto.randomBytes 20, (err, buf) ->
            done err, buf.toString 'hex'

        (token, done) ->
          {email} = req.body
          user.findOne {email}, (err, user) ->
            user.resetToken = token
            user.tokenExpires = Date.now() + 1000 * 60 * 60 # 1 Hour.
            user.save (err) ->
              done err, token, user
              console.log "Token #{token} generated for #{email}"

      ], (err) ->
        res.send 'done'
module.exports = (app) -> new Routes app
