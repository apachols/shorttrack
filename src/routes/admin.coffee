User = require '../models/User'
util = require 'util'

class Admin
  constructor: (@app) ->
    @locals =
      brand: 'Admin Console'

    # Require authentication for all admin routes
    @app.all /^\/admin/, @auth

    # Route the admin requests.
    @app.get '/admin/user/:email', @validate, @user
    @app.get '/admin', @home

  auth: (req, res, next) ->
    return res.send 'boo-urns', 401 unless req.isAuthenticated()
    next()

  validate: (req, res, next) ->
    req.assert('email', 'Must supply a valid email').isEmail()
    errors = req.validationErrors()

    if errors
      req.flash 'error', util.inspect errors
      res.redirect '/admin'

    else next()

  user: (req, res) ->
    {email} = req.params
    User.findOne {email}, (err, user) ->

      if user
        user?.inspect = util.inspect user
        res.render 'admin/user', {user}

      else res.send 404, err

  home: (req, res) ->
    User.find {}, (err, users) ->
      if users then res.render 'admin/home', {users}
      else res.send 500, err

module.exports = (app) -> new Admin app
