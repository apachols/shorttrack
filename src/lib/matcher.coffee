UserModel = require '../../src/models/user'
MatchModel = require '../../src/models/match'
MeetupModel = require '../../src/models/meetup'
mongoose = require 'mongoose'

# The matcher takes a meetup record, pulls all users registered for that meetup,
# and generates Match records for all users who are able to match
class Matcher
  constructor: (@meetup) ->
    @errors = []

  # we expect stanadard (error, result) args on callback
  execute: (pool, callback) ->
    console.log '@execute'

    @getUsers pool, (err, users) =>
      console.log '@getUsers callback'
      callback err, null if err
      @generateMatches users, callback

  # find all users (registered for this meetup)
  getUsers: (pool, callback) ->
    console.log '@getUsers'

    userids = []
    for userid in @meetup[pool]
      console.log userid
      userids.push mongoose.Types.ObjectId userid.toString()

    # only schedule dates for registered users.
    # eventually only do this for checked/in paid users
    findSpec = _id: $in: userids

    UserModel.find findSpec, (err, users) ->
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

      if !arity[left._id] then arity[left._id] = 0

      # right side: each of the remaining users in the list
      while iter--
        right = users[iter]

        if !arity[right._id] then arity[right._id] = 0

        # if our left side is ok to match with our right side
        if @okToMatch left, right

          arity[left._id]++
          arity[right._id]++

          # Calculate match percent score
          score = @score left, right
          # Save the match info for batch db insert
          matches.push
            user1:
              name: left.profile[0].name
              userid: left._id
              arity: 0
            user2:
              name: right.profile[0].name
              userid: right._id
              arity: 0
            score: score
            round: 0

    for match in matches
      match.user1.arity = arity[match.user1.userid]
      match.user2.arity = arity[match.user2.userid]
      match.arity = arity[match.user1.userid]+arity[match.user2.userid]

    @meetup.matches = matches

    MeetupModel.findOneAndUpdate
      name: @meetup.name
    , matches: matches
    , (err, meetup) ->
      console.log 'MeetupModel.findOneAndUpdate'
      callback err, matches

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
    numberOfMatchesToClear = @meetup.matches.length
    MeetupModel.findOneAndUpdate
      name: @meetup.name
    , matches: []
    , (err, meetup) ->
      console.log 'MeetupModel.findOneAndUpdate'
      callback err, numberOfMatchesToClear

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
