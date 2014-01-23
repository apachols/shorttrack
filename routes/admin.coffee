mongoose = require 'mongoose'
User = mongoose.model 'User', require '../models/User'
_ = require 'lodash'
util = require 'util'

class Admin
  constructor: (@app) ->
    @locals =
      brand: 'Admin Console'

    # Require authentication for all admin routes
    @app.all /^\/admin/, @auth

    # Route the admin requests.
    @app.get '/admin/:username', @user
    @app.get '/admin', @home

  auth: (req, res, next) ->
    return res.send 'boo-urns', 401 unless req.isAuthenticated()
    next()

  home: (req, res) ->
    User.find {}, (err, users) ->
      throw err if err

      _.assign res.locals, @locals, {
        errors: req.session.errors
        users: users
        my: req.user
      }

      req.session.errors = false
      res.render 'admin/home'

  user: (req, res) ->
    req.assert('username', 'Must supply a valid username').isAlphanumeric()
    errors = req.validationErrors()
    unless errors
      User.findOne {
        'username': req.params.username
      }, (err, user) ->
        throw err if err

        user?.inspect = util.inspect user

        _.assign res.locals, @locals, {
          errors: req.session.errors
          user: user
          my: req.user
        }

        if user
          res.render 'admin/user'
        else
          res.send "<b>#{req.params.username}</b> is <i>not</i> the username you are looking for.", 404

    else
      req.session.errors = util.inspect errors
      res.redirect 400, '/admin'

module.exports = (app) -> new Admin app
