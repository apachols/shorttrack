mongoose = require 'mongoose'

mongoose.connect(
  'mongodb://adam:password1220@dbh76.mongolab.com:27767/openspeeddating'
)

MeetupModel = require '../../../src/models/meetup'

Scheduler = require '../../../src/lib/scheduler'

MeetupModel.findOne {name: 'Segan Says'}, (err, meetup)->
  console.error err if err

  s = new Scheduler(meetup)

  s.getMatches (matches) ->
    console.error err if err

    matches = s.executeGreedyStrategy matches, 8

    # console.dir matches

    console.log "FINISH"

    mongoose.connection.close()
