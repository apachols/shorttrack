MatchModel = require '../../src/models/Match'
_ = require "lodash"

shuffle = require '../../src/lib/shuffle'

class BlossomScheduler
  constructor: () ->

  execute: (callback) ->
    console.log '@execute'

    @getMatches (err, matches) =>
      console.log '@getUsers callback'
      callback err, null if err
      @scheduleRounds matches, callback

  # pull in all match records in order of
  getMatches: (callback) ->
    console.log '@getMatches'

    # @meetup.getRegisteredUsers()
    MatchModel.find({}).sort({ 'arity.total': 1 }).exec (err, matches) ->
      console.log 'MatchModel.find callback'
      # shuffle.shuffle(matches)
      callback err, matches

  constructGraph: (matches, callback) ->
    matrix = []
    roster = []

    for match in matches
      index1 = roster.indexOf(match.user1)
      if index1 == -1
        roster.push match.user1

      index2 = roster.indexOf(match.user2)
      if index2 == -1
        roster.push match.user2

    ii = 0
    while ii < roster.length
      matrix[ii] = []
      jj = 0
      while jj < roster.length
        matrix[ii][jj] = 0
        jj++
      ii++

    for match in matches

      index1 = roster.indexOf(match.user1)
      index2 = roster.indexOf(match.user2)

      matrix[index1][index2] = 1
      matrix[index2][index1] = 1

    callback null, {matrix,roster}

  # return errors generated during the scheduling process
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

module.exports = BlossomScheduler
