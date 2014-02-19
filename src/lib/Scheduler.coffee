MatchModel = require '../../src/models/Match'
_ = require "lodash"

class Scheduler
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
    MatchModel.find({}).sort({ score: -1 }).exec (err, matches) ->
      console.log 'MatchModel.find callback'
      callback err, matches

  scheduleRounds: (matches, callback) ->
    # while number added during last round > 0

    result = []

    round = 1
    while true
      console.error 'ROUND ' + round + ': FIGHT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
      roundTotal = 0

      toUpdate = []
      unavailable = []

      iter = 0
      for match in matches
        iter++
        if !match.round
          console.log iter, 'MATCH', match.user1, match.user2

          okUser1 = -1 == unavailable.indexOf match.user1
          okUser2 = -1 == unavailable.indexOf match.user2
          if okUser1 and okUser2

            roundTotal++
            unavailable.push match.user1, match.user2
            toUpdate.push match._id
            match.round = roundTotal
            console.log '                         unavailable', unavailable.length, 'toUpdate', toUpdate.length, 

      result.push "round " + round + " totalMatches " + roundTotal
      round++

      break if !roundTotal

    callback null, result

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

module.exports = Scheduler
