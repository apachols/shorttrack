mongoose = require 'mongoose'

Match = new mongoose.Schema
  seat: Number
  user1:
    name: String
    email: String
    arity: Number
    vote: Number
  user2:
    name: String
    email: String
    arity: Number
    vote: Number
  round: Number
  arity: Number
  score:
    type: [ Number ], index: true
,
  collection: 'match'
  strict: 'throw'

module.exports = mongoose.model 'Match', Match
