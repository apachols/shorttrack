GenderModel = require '../models/Gender'
util = require 'util'

# routes for /admin/gender/*
class Gender
  constructor: (@app) ->
    @locals =
      brand: 'Edit Gender'

    @app.get '/admin/gender/:code', @gender

  # display a single gender for editing - /admin/gender/:code
  gender: (req, res) ->
    {code} = req.params

    GenderModel.findOne {code}, (err, gender) ->

      if gender
        gender?.inspect = util.inspect gender
        res.render 'admin/gender', {gender}

      else
        req.flash 'error', 'Gender not found: ' + code
        res.redirect '/admin'

module.exports = (app) -> new Gender app
