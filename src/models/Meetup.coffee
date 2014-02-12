mongoose = require 'mongoose'

Meetup = new mongoose.Schema
  name: String
  date: Date
  time: [ String ]
  registration: [ Date ]
  description: String
  location: String
  registered: [ String ]
,
  collection: 'meetup'
  strict: 'throw'

module.exports = mongoose.model 'Meetup', Meetup
