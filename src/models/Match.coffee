mongoose = require 'mongoose'

Match = new mongoose.Schema
  seat: Number
  user1: String
  user2: String
  round: Number
  arity:
    user1: Number
    user2: Number
    total: Number
  score:
    type: [ Number ], index: true
,
  collection: 'match'
  strict: 'throw'

module.exports = mongoose.model 'Match', Match
