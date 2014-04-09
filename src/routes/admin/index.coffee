UserModel = require '../../models/User'
util = require 'util'

class Admin
  constructor: (@app) ->
    @locals =
      brand: 'Admin Console'

    # Require authentication for all admin routes
    @app.all /^\/admin/, @auth

    # Route the /admin requests.
    @app.get '/admin', @home

    # Set up all the /admin/user routes!
    User = require('./User') @app
    Gender = require('./Gender') @app

  auth: (req, res, next) ->
    authenticated = req.isAuthenticated() and req.user?.admin
    return res.send 401, 'boo-urns' unless authenticated
    next()

  home: (req, res) ->
    UserModel.find {}, (err, users) ->
      if users then res.render 'admin/home', {users}
      else res.send 500, err

  update: (req, res) ->
    {email} = req.body #post
    User.findOne {email}, (err, user) ->
      if user then res.send 200, user
      else res.send 500, err

module.exports = (app) -> new Admin app
