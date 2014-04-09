mongoose = require 'mongoose'

Question = new mongoose.Schema
  text: String
  name: String
  answer: String
  answers: [ String ]
  acceptable: [ String ]
  importance: Number
,
  collection: 'question'
  strict: 'throw'

module.exports = mongoose.model 'Question', Question
