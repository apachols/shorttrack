mongoose = require 'mongoose'

Meetup = new mongoose.Schema
  name: String
  date: Date
  cap: Number
  time: [ Date ]
  registration: [ Date ]
  description: String
  location: String
  registered: [ String ]
,
  collection: 'meetup'
  strict: 'throw'

module.exports = mongoose.model 'Meetup', Meetup
