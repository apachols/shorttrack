async = require 'async'
crypto = require 'crypto'
User = require '../models/user'

module.exports = (app) ->

  # Generate a token, and expiration date for a user.
  app.post '/forgot', (req, res) ->
    {email} = req.body

    async.waterfall [
      (done) ->
        crypto.randomBytes 20, (err, buf) ->
          done err, buf.toString 'hex'

      (token, done) ->
        User.findOne {email}, (err, user) ->
          return done err, user, token if user
          done 'User does not exist!'

      (user, token, done) ->
          user.resetToken = token
          user.tokenExpires = Date.now() + 1000 * 60 * 60 # 1 Hour.
          user.save done

    ], (err) ->
      return res.send 500, err if err
      res.send 200

  # Verify a user token, and reset the password
  app.post '/reset', (req, res) ->
    {email, password, confirm, token} = req.body

    async.waterfall [
      (done) ->
        return done null if confirm is password
        done "Password Mismatch"

      (done) ->
        User.findOne {email}, (err, user) ->
          return done err, user if user
          done 'User does not exist!'

      (user, done) ->
        return done null, user if token is user.resetToken
        done "Token Mismatch"

      #@todo  check token expiration

      (user, done) ->
        user.setPassword password, done

      (user, done) ->
        user.save done

    ], (err) ->
      return res.send 400, err if err
      res.send 200
