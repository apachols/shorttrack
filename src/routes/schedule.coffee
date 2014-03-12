MeetupModel = require '../models/meetup'
Matcher = require '../lib/Matcher'
Scheduler = require '../lib/Scheduler'


class Schedule
  constructor: (@app) ->
    @app.get '/schedule/:name', @get

  get: (req, res) ->
    {name} = req.params

    MeetupModel.findOne {name}, (err, meetup) ->
      m = new Matcher(meetup)
      s = new Scheduler(meetup)

      m.execute (err, count) ->
        console.error err if err
        console.log 'Created ' + count + ' matches'

        s.getMatches (matches) ->
          console.error err if err

          s.scheduleRounds matches, (err, result) ->
            console.error err if err
            console.log result.length + ' rounds'
            for r in result
              console.dir r
            console.log 'Test Schedule Rounds Complete'
            # redirect to the meetup - db should be up to date!
            res.redirect "/meetup/#{name}"

module.exports = (app) -> new Schedule app
