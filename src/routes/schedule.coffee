MeetupModel = require '../models/meetup'
Matcher = require '../lib/Matcher'
Scheduler = require '../lib/Scheduler'
util = require 'util'

class Schedule
  constructor: (@app) ->
    @app.get '/meetup/:name/generate', @generate
    @app.get '/meetup/:name/schedule/:user', @displayUser

  displayUser: (req, res) ->
    {name, user} = req.params
    MeetupModel.findOne {name}, (err, meetup) ->
      return res.send util.inspect err if err
      meetup.getScheduleUser user, (matches) ->
        res.send util.inspect matches

  generate: (req, res) ->
    {name} = req

    MeetupModel.findOne {name}, (err, meetup) ->
      m = new Matcher(meetup)
      s = new Scheduler(meetup)

      m.execute (err, matches) ->
        console.error err if err
        console.log 'Created ' + matches.length + ' matches'

        s.scheduleRounds matches, (err, result) ->
          console.error err if err
          console.log result.length + ' rounds'
          for r in result
            console.dir r
          console.log 'Test Schedule Rounds Complete'
          # redirect to the meetup - db should be up to date!
          res.redirect "/meetup/#{name}"

module.exports = (app) -> new Schedule app
