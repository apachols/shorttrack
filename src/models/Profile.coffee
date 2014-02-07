mongoose = require 'mongoose'
Questions = new mongoose.Schema
Gender = require './Gender'

Profile = new mongoose.Schema
  name: String
  nickname: String

  gender: {
    my: String
    seeking: [Gender]
    avoid: [Gender]
  }

  age: {
    my: Number
    min: Number
    max: Number
  }

  questions: [Questions.schema]
,
  collection: 'profile'

module.exports = mongoose.model 'Profile', Profile
