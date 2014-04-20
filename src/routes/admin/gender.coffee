GenderModel = require '../../models/gender'
util = require 'util'

# routes for /admin/gender/*
class Gender
  constructor: (@app) ->
    @locals =
      brand: 'Edit Gender'

    @app.get '/admin/gender/:id', @get

  # display a single gender for editing - /admin/gender/:code
  get: (req, res) ->
    {id} = req.params

    GenderModel.findOne { "_id": id }, (err, gender) ->

      if gender
        gender.inspect = util.inspect gender
        res.render 'admin/gender', {gender}

      else
        req.flash 'error', 'Gender not found: ' + id
        res.redirect '/admin'

module.exports = (app) -> new Gender app
