mongoose = require 'mongoose'

Profile = new mongoose.Schema(
  gender: String
  genderSought: String
  genderSecond: String
  age: Number
  ageSoughtMin: Number
  ageSoughtMax: Number
,
  collection: 'profile'
  strict: 'throw'
)

module.exports = mongoose.model 'Profile', Profile