#/genders

mongoose = require 'mongoose'
Gender = mongoose.model 'Gender', require '../models/Gender'
_ = require 'lodash'
util = require 'util'

locals = {
  brand: ': Genders'
}

exports.list = (req, res) ->
  unless req.isAuthenticated() then res.send 'boo-urns', 401

  Gender.find {}, (err, genders) ->
    throw err if err

    res.locals = _.extend locals, {
      errors: req.session.errors
      singleUser: false
      genders: genders
      my: req.user
    }

    req.session.errors = false
    res.render 'admin/genders'