mongoose = require 'mongoose'

Match = require './Match'

Meetup = new mongoose.Schema
  name: String
  date: Date
  cap: Number

  minutes: Number
  hours: Number
  am:
    default: false
    type: Boolean

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

Meetup.methods.isRegistered = (email) ->
  return -1 isnt @registered.indexOf email

Meetup.methods.getScheduleAll = (callback) ->
  filtered = @matches.filter (match) ->
    if match.round is 0
      return false
    return true

  callback filtered.sort (a,b)->
    return -1 if a.round < b.round
    return 1 if a.round > b.round
    return 0

Meetup.methods.getScheduleUser = (email, callback) ->
  filtered = @matches.filter (match) ->
    if match.round is 0
      return false
    if -1 != [match.user1.email, match.user2.email].indexOf email
      return true
    return false

  callback filtered.sort (a,b)->
    return -1 if a.round < b.round
    return 1 if a.round > b.round
    return 0

try module.exports = mongoose.model 'Meetup', Meetup
catch e then module.exports = mongoose.model 'Meetup'
