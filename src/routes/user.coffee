UserModel = require '../models/User'
util = require 'util'

class User
  constructor: (@app) ->
    @locals =
      brand: 'Edit User'

    @app.get '/admin/user/:email', @validate, @user

  validate: (req, res, next) ->
    req.assert('email', 'Must supply a valid email').isEmail()
    errors = req.validationErrors()

    if errors
      req.flash 'error', util.inspect errors
      res.redirect '/admin'

    else next()

  user: (req, res) ->
    {email} = req.params
    UserModel.findOne {email}, (err, user) ->

      if user
        user?.inspect = util.inspect user
        res.render 'admin/user', {user}

      else res.send 404, err

module.exports = (app) -> new User app
