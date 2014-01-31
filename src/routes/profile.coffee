User = require('../models/User')

class Profile
  constructor: (@app) ->
    @app.all /^\/profile/, @auth

    @app.get '/profile', @get

    @app.get '/profile/update', @update

  auth: (req, res, next) ->
    return res.send 'boo-urns', 401 unless req.isAuthenticated()
    next()

  get: (req, res) ->
    res.render 'profile', {
      brand: 'Profile'
      user: req.user
    }

  update: (req, res) ->
    console.log('UPDATE')

    dummyProfile =
      fakeKeyBadness: 'Lame!'
      gender: 'F'
      genderSought: 'F'
      genderSecond: 'M'
      age: 24
      ageSoughtMin: 22
      ageSoughtMax: 32

    req.user.profile = dummyProfile

    req.user.save (err, profile) ->
      console.log(err) if err

    res.redirect '/profile'



module.exports = (app) -> new Profile app
