mongoose = require 'mongoose'
Gender = require './Gender'

# TODO - make the question schema
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

# return false if the other profile is not what this user is seeking
Profile.methods.okToMatch = (profile) ->
  return false if -1 == this.gender.seeking.indexOf(profile.gender.my)
  return false if profile.age.my < this.age.seeking[0] or
                  profile.age.my > this.age.seeking[1]
  return true

# OKC Matching:
# Compute a numeric score between [0,1] representing how well our profile's
# acceptable question answers are matched by the answers in the Other's
# profile
Profile.methods.computeScore = (profile) ->

  # Prepare a quick reference of the Other's answers; that's all we'll need
  # to determine how well they match what we're looking for
  questionsRef = {}
  for question in profile.questions
    questionsRef[question.name] = question.answer

  points = 0
  possible = 0
  inCommon = 0
  # for all the questions we've answered
  for question in this.questions

    theirAnswer = questionsRef[question.name]
    # if they have answered the same question
    if theirAnswer?

      # keep track of how many points they can get for this question
      possible += question.importance
      # and mark it as a question that both parties answered
      inCommon++

      if -1 != question.acceptable.indexOf theirAnswer
        # I choo-choo-chose something you found acceptable; award all points
        points += question.importance

  return {
    score: points / possible
    common: inCommon
  }

try module.exports = mongoose.model 'Profile', Profile
catch e then module.exports = mongoose.model 'Profile'
