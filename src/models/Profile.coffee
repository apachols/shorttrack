mongoose = require 'mongoose'
Gender = require './Gender'

# Temp
Profile = new mongoose.Schema
  name: String
  nickname: String

  gender:[
    new mongoose.Schema
      my: String
      seeking: [String]
      avoid: [String]
  ]

  age: [
    new mongoose.Schema
      my: Number
      range: [Number]
  ]

  questions: [new mongoose.Schema]
,
  collection: 'profile'

module.exports = mongoose.model 'Profile', Profile
