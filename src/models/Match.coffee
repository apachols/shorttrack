mongoose = require 'mongoose'

Match = new mongoose.Schema
  user1: String
  user2: String
  score:
    type: [ Number ], index: true
,
  collection: 'match'
  strict: 'throw'

module.exports = mongoose.model 'Match', Match
