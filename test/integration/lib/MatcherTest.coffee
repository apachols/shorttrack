mongoose = require 'mongoose'

mongoose.connect(
  'mongodb://adam:password1220@dbh76.mongolab.com:27767/openspeeddating'
)

Matcher = require '../../../src/lib/Matcher'

MeetupModel = require '../../../src/models/Meetup'

MeetupModel.findOne {name: 'Meetup 2'}, (err, meetup)->
  m = new Matcher(meetup)
  m.clearMatches (err, count) ->
    console.error err if err
    console.log 'Cleared ' + count + ' matches'
    m.execute (err, count) ->
      console.error err if err
      console.log 'Created ' + count + ' matches'