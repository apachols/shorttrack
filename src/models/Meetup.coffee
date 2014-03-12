mongoose = require 'mongoose'

Match = require './Match'

Meetup = new mongoose.Schema
  name: String
  date: Date
  cap: Number

  time:
    start: String
    stop: String

  registration:
    open: Date
    close: Date

  description: String
  location: String
  registered: [ String ]
  matches: [ Match.schema ]
,
  collection: 'meetup'
  strict: 'throw'

Meetup.methods.getScheduleAll = (callback) ->
  callback this.matches.sort (a,b)->
    return -1 if a.round.total < b.round.total
    return 1 if a.round.total > b.round.total
    return 0

Meetup.methods.getScheduleUser = (username, callback) ->
  filtered = this.matches.filter (match) ->
    return true if username='janenash@sloganaut.com'
    # return true if -1 != [match.user1, match.user2].indexOf username

  callback filtered.sort (a,b)->
    return -1 if a.round.total < b.round.total
    return 1 if a.round.total > b.round.total
    return 0

try module.exports = mongoose.model 'Meetup', Meetup
catch e then module.exports = mongoose.model 'Meetup'