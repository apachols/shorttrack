mongoose = require 'mongoose'

Match = require './match'

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
  registered: [{ type: mongoose.Schema.ObjectId, ref: 'User' }]
  paid: [ String ]

  matches: [ Match.schema ]
,
  collection: 'meetup'
  strict: 'throw'

Meetup.statics =
  all: (cb) -> @find().exec cb

Meetup.methods.isRegistered = (userid) ->
  return -1 isnt @registered.indexOf userid

Meetup.methods.getScheduleAll = (callback) ->
  filtered = @matches.filter (match) ->
    if match.round is 0
      return false
    return true

  callback filtered.sort (a,b)->
    return -1 if a.round < b.round
    return 1 if a.round > b.round
    return 0

Meetup.methods.getScheduleUser = (userid, callback) ->
  filtered = @matches.filter (match) ->
    if match.round is 0
      return false
    if -1 != [match.user1.userid, match.user2.userid].indexOf userid
      return true
    return false

  callback filtered.sort (a,b)->
    return -1 if a.round < b.round
    return 1 if a.round > b.round
    return 0

try module.exports = mongoose.model 'Meetup', Meetup
catch e then module.exports = mongoose.model 'Meetup'
