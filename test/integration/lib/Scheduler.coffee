mongoose = require 'mongoose'

mongoose.connect(
  'mongodb://adam:password1220@dbh76.mongolab.com:27767/openspeeddating'
)

MeetupModel = require '../../../src/models/Meetup'

Scheduler = require '../../../src/lib/Scheduler'

MeetupModel.findOne {name: 'Meetup 2'}, (err, meetup)->
  console.error err if err
  s = new Scheduler(meetup)
  s.getMatches (matches) ->
    console.error err if err
    s.scheduleRounds matches, (err, result) ->
      console.log result.length + ' rounds'
      for r in result
        console.dir r
      console.log 'Test Schedule Rounds Complete'

mongoose.connection.close()