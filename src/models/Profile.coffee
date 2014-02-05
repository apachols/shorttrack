mongoose = require 'mongoose'
Questions = new mongoose.Schema

Profile = new mongoose.Schema
  name: String
  handle: String

  gender: {
    my: String
    seeking: []
    avoid: []
  }

  age: {
    my: Number
    min: Number
    max: Number
  }

  questions: [Questions.schema]
,
  collection: 'profile'
  strict: 'throw'

module.exports = mongoose.model 'Profile', Profile
