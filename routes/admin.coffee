#/admin

mongoose = require 'mongoose'
User = mongoose.model 'User', require '../models/User'
_ = require 'lodash'
util = require 'util'

locals = {
  brand: 'Admin Console'
}

exports.home = (req, res) ->
  unless req.isAuthenticated() then res.send 'boo-urns', 401

  User.find {}, (err, users) ->
    throw err if err

    res.locals = _.extend locals, {
      errors: req.session.errors
      singleUser: false
      users: users
      my: req.user
    }

    req.session.errors = false
    res.render 'admin/home'

exports.user = (req, res) ->
  unless req.isAuthenticated() then res.send 'boo-urns', 401

  console.log(res)
  req.assert('username', 'Must supply a valid username').isAlphanumeric()

  errors = req.validationErrors()
  unless errors
    User.findOne {
      'username': req.params.username
    }, (err, user) ->
      throw err if err

      user.inspect = util.inspect(user)

      res.locals = _.extend locals, {
        singleUser: true
        user: user
        my: req.user
      }

      res.render 'admin/user'

  else
    req.session.errors = util.inspect errors
    res.redirect 400, '/admin'
