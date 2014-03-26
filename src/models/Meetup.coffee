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
  callback @matches.sort (a,b)->
    return -1 if a.round < b.round
    return 1 if a.round > b.round
    return 0

Meetup.methods.getScheduleUser = (email, callback) ->
  filtered = @matches.filter (match) ->
    # console.log match.user1, match.user2
    if -1 != [match.user1, match.user2].indexOf email
      # console.log 'HERE IT IS'
      return true
    return false

  callback filtered.sort (a,b)->
    return -1 if a.round < b.round
    return 1 if a.round > b.round
    return 0

try module.exports = mongoose.model 'Meetup', Meetup
catch e then module.exports = mongoose.model 'Meetup'
