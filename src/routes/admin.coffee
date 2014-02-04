User = require '../models/User'
util = require 'util'

class Admin
  constructor: (@app) ->
    @locals =
      brand: 'Admin Console'

    # @TODO Move to after @auth when working
    @app.all '/admin/update', @update

    # Require authentication for all admin routes
    @app.all /^\/admin/, @auth

    # Route the admin requests.
    @app.get '/admin/user/:email', @validate, @user
    @app.get '/admin', @home

    @app.post '/admin/user/profile/update/:email', @validate, @updateUserProfile

    @app.post '/admin/user/update/:email', @validate, @updateUser

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

  update: (req, res) ->
    {email} = req.body #post
    {email} = req.query unless email #get
    User.findOne {email}, (err, user) ->
      if user then res.send 200, user
      else res.send 500, err

  updateUserProfile: (req, res) ->
    {pk, name, value} = req.body

    findSpec =
      email: pk

    User.findOne findSpec, (err,user) ->
      if err then res.send 'DB error', 500

      if user == null then res.send 'Invalid user', 400

      try
        user.profile[0][name] = value
        user.save()
        res.send 200

      catch e
        console.error e
        res.send 'Invalid update request', 400

  updateUser: (req, res) ->
    console.log 'updateUser'


module.exports = (app) -> new Admin app
