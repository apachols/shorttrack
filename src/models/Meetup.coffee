mongoose = require 'mongoose'

Match = require './Match'

Meetup = new mongoose.Schema
  name: String
  date: Date
  cap: Number

  time:
    start: Date
    stop: Date

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

try module.exports = mongoose.model 'Meetup', Meetup
catch e then module.exports = mongoose.model 'Meetup'