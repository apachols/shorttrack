GenderModel = require '../../models/gender'
util = require 'util'

# routes for /admin/gender/*
class Gender
  constructor: (@app) ->
    @locals =
      brand: 'Edit Gender'

    @app.get '/admin/gender/:_id', @get

  # display a single gender for editing - /admin/gender
  get: (req, res) ->
    {_id} = req.params
    res.render 'admin/gender', {_id}

module.exports = (app) -> new Gender app
