async = require 'async'
crypto = require 'crypto'
User = require '../models/user'

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

    @app.post '/forgot', (req, res) ->
      async.waterfall [
        (done) ->
          crypto.randomBytes 20, (err, buf) ->
            done err, buf.toString 'hex'

        (token, done) ->
          {_id} = req.body
          User.findOne {_id}, (err, user) ->
            user.resetToken = token
            user.tokenExpires = Date.now() + 1000 * 60 * 60 # 1 Hour.
            user.save (err) ->
              done err, token, user
              console.log "Token #{token} generated for #{user.email}"

      ], (err, token, user) ->
        res.json user

    @app.post '/reset', (req, res) ->
      {_id, password, confirm, token} = req.body

      if confirm is password
        User.findOne {_id}, (err, user) ->

          return res.send 400, "Invalid Userid: #{err}" if err

          if token is user.resetToken
            async.waterfall [
              (done) ->
                user.setPassword password, (err) ->
                  done err

              (done) ->
                user.save (err) ->
                  done err

            ], (err) ->
              res.send 200

          else res.send 400, "Token mismatch"
      else res.send 400, "Password mismatch"

module.exports = (app) -> new Routes app
