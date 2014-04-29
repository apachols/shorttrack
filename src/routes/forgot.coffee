async = require 'async'
crypto = require 'crypto'

User = require '../models/user'
nodemailer = require 'nodemailer'
transport = nodemailer.createTransport 'sendmail'

module.exports = (app) ->

  # Generate a token, and expiration date for a user.
  app.post '/forgot', (req, res) ->
    {email} = req.body
    domain = "localhost"
    port = 3000

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
          user.save ->
            done null, user, token

      (user, token, done) ->
        text = """
          To reset your password, please click on this link.
          http://#{domain}#{':' + port if port isnt 80}/reset/#{user.email}/#{token}
          Password reset token: #{token}
        """
        transport.sendMail
          from: 'forgot@shorttrack.me'
          to: user.email
          subject: 'Password Reset Instructions'
          text: text
        , done

    ], (err) ->
      return res.send 500, err if err
      res.send 200


  # Show the form to enter your confirmation passwords.
  app.get '/reset/:email?/:token?', (req, res) ->
    {email, token} = req.params
    res.render 'forgot', {email, token}

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
