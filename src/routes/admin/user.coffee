UserModel = require '../../models/User'
util = require 'util'

# routes for /admin/user/*
class User
  constructor: (@app) ->
    @locals =
      brand: 'Edit User'

    @app.get '/admin/user/:email', @validate, @user

  # validate that url parameter email is valid
  validate: (req, res, next) ->
    req.assert('email', 'Must supply a valid email').isEmail()
    errors = req.validationErrors()

    if errors
      req.flash 'error', util.inspect errors
      res.redirect '/admin'

    else next()

  # display a single user for editing - /admin/user/:email
  user: (req, res) ->
    {email} = req.params
    UserModel.findOne {email}, (err, user) ->

      if user
        res.render 'admin/user', {user, description: util.inspect user}
      else
        req.flash 'error', 'User not found: ' + email
        res.redirect '/admin'

module.exports = (app) -> new User app
