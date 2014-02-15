UserModel = require '../../src/models/User'
MatchModel = require '../../src/models/Match'
QuestionModel = require '../../src/models/Question'

class Matcher
  constructor: (meetup) ->
    @meetup = meetup

  # we expect stanadard (error, result) args on callback
  execute: (callback) ->
    console.log '@execute'
    @getUsers (err, users) =>
      console.log '@getUsers callback'
      callback err, null if err
      @generateMatches users, callback

  # find all users (registered for this meetup)
  getUsers: (callback) ->
    console.log '@getUsers'

    # @meetup.getRegisteredUsers()
    UserModel.find {'profile.0.gender.seeking' : { $exists : true } }, (err, users) ->
      console.log 'model.find callback'
      console.log users.length if users?.length
      callback err, users

  # returns list of matches in memory
  generateMatches: (users, callback) ->
    console.log '@generateMatches'

    return callback 'No users found', null if !users

    matches = []
    while users.length
      left = users.pop()
      console.log left?.profile[0]?.gender
      iter = users.length
      while iter--
        right = users[iter]
        if @okToMatch left, right
          score = @score left, right
          matches.push
            user1: left.email
            user2: right.email
            score: score

    MatchModel.create matches, (err) ->
      console.log 'MatchModel.create callback'
      callback err, arguments.length-1

  okToMatch: (left, right) ->
    if left?.profile[0]?.gender && right?.profile[0]?.gender

      if left.profile[0].gender?.seeking?.length > 0
        console.dir left.profile[0].gender.seeking
        return true

      if right.profile[0].gender?.seeking?.length > 0
        console.dir right.profile[0].gender.seeking
        return true

      return false

  score: (left, right) ->
    return 2

  # remove all matches from the DB
  clearMatches: (callback) ->
    console.log '@clearMatches'
    MatchModel.remove {}, (err, count) ->
      console.log 'MatchModel.remove callback'
      callback err, count

module.exports = Matcher
