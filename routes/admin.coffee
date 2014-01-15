#/admin

User = require '../models/User'
inspect = require('util').inspect

exports.home = (req, res) ->
  unless req.isAuthenticated() then res.send 'boo-urns', 401

  humans = User.find()
  res.render 'admin', {
    user: req.user
    humans: 
      data: humans
      inspect: inspect(humans)
  }

