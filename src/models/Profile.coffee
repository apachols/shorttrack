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
  strict: 'throw'

Profile.methods.computeScore = (profile) ->
  questionsRef = {}

  # quick question lookup for the compared person
  for question in profile.questions
    questionsRef[question.name] = question.answer

  points = 0
  possible = 0
  inCommon = 0
  for question in this.questions 
    theirAnswer = questionsRef[question.name]
    if theirAnswer?
      # we're keeping score now, add in the possible points
      possible += question.importance
      inCommon++

      if -1 != question.acceptable.indexOf theirAnswer
        # I choo-choo-chose something you found acceptable; all your points are belong to me
        points += question.importance

  return {
    score: points / possible
    common: inCommon    
  }

try module.exports = mongoose.model 'Profile', Profile
catch e then module.exports = mongoose.mongoose 'Profile'
