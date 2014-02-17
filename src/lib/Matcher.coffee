UserModel = require '../../src/models/User'
MatchModel = require '../../src/models/Match'
QuestionModel = require '../../src/models/Question'

class Matcher
  constructor: (meetup) ->
    @meetup = meetup
    @errors = []

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
    UserModel.find {}, (err, users) ->
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

  okToMatch: (leftUser, rightUser) ->
    gender1 = leftUser.profile[0]?.gender
    gender2 = rightUser.profile[0]?.gender

    age1 = leftUser.profile[0]?.age
    age2 = rightUser.profile[0]?.age

    # bail if we are missing the required fields
    # will eventually need some error reporting here...
    return false if !gender1?.my or !gender1?.seeking
    return false if !gender2?.my or !gender2?.seeking
    return false if !(age1?.my) or !(age1?.seeking)
    return false if !(age2?.my) or !(age2?.seeking)

    return false if -1 == gender1.seeking.indexOf(gender2.my)
    return false if -1 == gender2.seeking.indexOf(gender1.my)

    if age1.my < age2.seeking[0] or age1.my > age2.seeking[1]
      console.log age1.my + ' ! ' + age2.seeking[0] + '-' + age2.seeking[1]
      return false

    if age2.my < age1.seeking[0] or age2.my > age1.seeking[1]
      console.log age2.my + ' ! ' + age1.seeking[0] + '-' + age1.seeking[1]
      return false

    return true

  score: (left, right) ->
    score1 = left.profile[0].computeScore(right.profile[0])
    score2 = right.profile[0].computeScore(left.profile[0])

    if score1.common != score2.common
      @errors.push 'NUMBER OF QUESTIONS IN COMMON DOES NOT MATCH; PANIC'

    result = Math.pow(score1.score * score2.score, 1/score1.common)
    console.log 'result = ' + result + ' common1 = ' + score1.common + ' common2 = ' + score2.common + ' pow = ' + 1/score1.common + ' score1 = ' + score1.score + ' score2 = ' + score2.score
    return result

  # remove all matches from the DB
  clearMatches: (callback) ->
    console.log '@clearMatches'
    MatchModel.remove {}, (err, count) ->
      console.log 'MatchModel.remove callback'
      callback err, count

module.exports = Matcher
