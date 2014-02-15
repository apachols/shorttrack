mongoose = require 'mongoose'
Gender = require './Gender'

# Temp
Questions = new mongoose.Schema

Profile = new mongoose.Schema
  name: String
  nickname: String

  gender: {
    my: String
    seeking: [String]
    avoid: [String]
  }

  age: {
    my: Number
    seeking: [Number]
  }

  questions: [Questions.schema]
,
  collection: 'profile'

module.exports = mongoose.model 'Profile', Profile
