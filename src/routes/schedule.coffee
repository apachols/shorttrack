MeetupModel = require '../models/meetup'
Matcher = require '../lib/Matcher'
Scheduler = require '../lib/Scheduler'
util = require 'util'

class Schedule
  constructor: (@app) ->
    # @app.get '/meetup/:name/generate', @generate
    # @app.get '/meetup/:name/schedule/:user', @displayUser

  displayUser: (req, res) ->
    {name, user} = req.params
    MeetupModel.findOne {name}, (err, meetup) ->
      return res.send util.inspect err if err
      meetup.getScheduleUser user, (matches) ->
        res.send util.inspect matches

module.exports = (app) -> new Schedule app
