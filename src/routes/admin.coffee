mongoose = require 'mongoose'
User = require('../models/User')
util = require 'util'

class Admin
  constructor: (@app) ->
    @locals =
      brand: 'Admin Console'

    # Require authentication for all admin routes
    @app.all /^\/admin/, @auth

    # Route the admin requests.
    @app.get '/admin/:email', @user
    @app.get '/admin', @home

  auth: (req, res, next) ->
    return res.send 'boo-urns', 401 unless req.isAuthenticated()
    next()

  user: (req, res) ->
    # req.assert('username', 'Must supply a valid username').isAlphanumeric()

    errors = req.validationErrors()
    unless errors

      @findUser req.params.email, @showUser

    else
      req.session.errors = util.inspect errors
      res.redirect 400, '/admin'

  findUser: (email, callback) ->
    User.findOne {
      'email': email
    }, callback

  showUser: (err, user) ->
    throw err if err

    user?.inspect = util.inspect user

    res.locals @locals
    res.locals {
      errors: req.session.errors
      user: user
      my: req.user
      brand: user.email
    }

    if user
      res.render 'admin/user'
    else
      res.send "unknown user: <b>#{req.params.email}</b>", 404

  home: (req, res) ->
    User.find {}, (err, users) ->
      throw err if err

      res.locals @locals
      res.locals {
        errors: req.session.errors
        users: users
        my: req.user
      }

      req.session.errors = false
      res.render 'admin/home'

module.exports = (app) -> new Admin app
