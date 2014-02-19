UserModel = require '../../src/models/User'
MatchModel = require '../../src/models/Match'

# The matcher takes a meetup record, pulls all users registered for that meetup,
# and generates Match records for all users who are able to match
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

  # for all match-able users, generate a match record
  # batch insert the records into the database when all the matching is done
  generateMatches: (users, callback) ->
    console.log '@generateMatches'

    return callback 'No users found', null if !users

    arity = {}
    matches = []
    # left side: pop each user out and try to match them with all the
    #            remaining users
    while users.length
      left = users.pop()
      iter = users.length

      if !arity[left.email] then arity[left.email] = 0

      # right side: each of the remaining users in the list
      while iter--
        right = users[iter]

        if !arity[right.email] then arity[right.email] = 0

        # if our left side is ok to match with our right side
        if @okToMatch left, right

          arity[left.email]++
          arity[right.email]++

          # Calculate match percent score
          score = @score left, right
          # Save the match info for batch db insert
          matches.push
            user1: left.email
            user2: right.email
            score: score
            round: 0

    for match in matches
      match.arity =
        user1: arity[match.user1]
        user2: arity[match.user2]
        total: arity[match.user1]+arity[match.user2]

    console.dir arity

    # insert all the matches into the database, and send the number of
    # matches created back in the callback's success argument
    MatchModel.create matches, (err) ->
      console.log 'MatchModel.create callback'
      callback err, arguments.length-1

  # returns true if left and right users are both
  # seeking the other's specified gender and age
  okToMatch: (left, right) ->
    try
      return left.profile[0].okToMatch(right.profile[0]) &&
             right.profile[0].okToMatch(left.profile[0])
    catch e
      @errors.push @createError left, right, 'Matcher.okToMatch: ' + e.message

    return false

  # OKC Matching:
  # - use Profile's computeScore method to calculate the 1-way match percent
  # - amortize product of scores by taking the N-th root,
  #   where N = number of questions in common
  score: (left, right) ->
    try
      score1 = left.profile[0].computeScore(right.profile[0])
      score2 = right.profile[0].computeScore(left.profile[0])
    catch e
      @errors.push @createError left, right, 'Matcher.score: ' + e.message
      return -1

    if score1.common != score2.common
      msg = 'Matcher.score: count(questions in common) does not match'
      @errors.push @createError left, right, msg

    Math.pow(score1.score * score2.score, 1/score1.common)

  # remove all match records from the DB
  clearMatches: (callback) ->
    console.log '@clearMatches'
    MatchModel.remove {}, (err, count) ->
      console.log 'MatchModel.remove callback'
      callback err, count

  # return errors generated during the matching process
  getErrors: () -> @errors

  # create   a new error
  # left:    a User
  # right:   a User
  # message: a string
  createError: (left, right, message) ->
    return {
      user1: left?.email
      user2: right?.email
      message: message
    }

module.exports = Matcher
