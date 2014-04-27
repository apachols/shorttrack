UserModel = require '../../models/user'
util = require 'util'

# routes for /admin/user/*
class User
  constructor: (@app) ->
    @locals =
      brand: 'Edit User'

    @app.get '/admin/user/:_id', @user

  # display a single user for editing - /admin/user/:email
  user: (req, res) ->
    {_id} = req.params
    UserModel.findOne {_id}, (err, user) ->

      if user
        res.render 'admin/user', {user, description: util.inspect user}
      else
        req.flash 'error', 'User not found: ' + email
        res.redirect '/admin'

module.exports = (app) -> new User app
