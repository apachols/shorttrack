mongoose = require 'mongoose'

mongoose.connect(
  'mongodb://adam:password1220@dbh76.mongolab.com:27767/openspeeddating'
)

Matcher = require '../../../src/lib/Matcher'

MeetupModel = require '../../../src/models/Meetup'

MeetupModel.findOne {name: 'Segan Says'}, (err, meetup)->
  m = new Matcher(meetup)
  m.clearMatches (err, count) ->
    console.error err if err
    console.log 'Cleared ' + count + ' matches'
    m.execute (err, matches) ->
      console.error err if err
      console.log 'Created ' + matches.length + ' matches'
      mongoose.connection.close()
