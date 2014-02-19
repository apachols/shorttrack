MatchModel = require '../../src/models/Match'
_ = require "lodash"

# are the same people being forgotten multiple rounds in a row?
# do the forgotten have any matches inside between themselves (no)?
# if we pick the BEST first round, do we win all the things?
# how do we evaluate whether we have found the best possible first round for a data set?
# we tried to match 60 people, and two of them had zero matches.  can we find them?

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
    MatchModel.find({}).sort({ 'arity.total': 1 }).exec (err, matches) ->
      console.log 'MatchModel.find callback'
      callback err, matches

  scheduleRounds: (matches, callback) ->
    # while number added during last round > 0

    result = []
    datescount = {}
    personlog = {}
    round = 1
    while true
      console.error 'ROUND ' + round + ': FIGHT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
      roundTotal = 0

      toUpdate = []
      unavailable = []

      iter = 0
      for match in matches

        personlog[match.user1] = '1'
        personlog[match.user2] = '1'

        iter++
        if !match.round
          console.log iter, 'MATCH', match.user1, match.user2, match.arity.total

          okUser1 = -1 == unavailable.indexOf match.user1
          okUser2 = -1 == unavailable.indexOf match.user2
          if okUser1 and okUser2

            if !datescount[match.user1]
              datescount[match.user1] = 1
            else
              datescount[match.user1] = datescount[match.user1] + 1

            if !datescount[match.user2]
              datescount[match.user2] = 1
            else
              datescount[match.user2] = datescount[match.user2] + 1

            # console.dir datescount
            console.log 'personlog', Object.keys(personlog).length, "datescount", Object.keys(datescount).length

            unavailable.push match.user1, match.user2
            toUpdate.push match._id
            roundTotal++
            match.round = roundTotal

      # sort the list again by arity descending - seems to perform almost as well as forgotten->top
      matches.sort (left, right) ->
        if left.arity.total > right.arity.total
          return 1
        if left.arity.total < right.arity.total
          return -1
        return 0

      forgotten = _.difference Object.keys(personlog), _.uniq unavailable
      # console.dir forgotten

      # sort by whether they were forgotten, with forgotten people on top
      matches.sort (left, right) ->
        sumleft = (-1 != forgotten.indexOf(left.user1)) or (-1 != forgotten.indexOf(left.user2))
        sumright = (-1 != forgotten.indexOf(right.user1)) or (-1 != forgotten.indexOf(right.user2))
        if sumleft < sumright
          return 1
        if sumleft > sumright
          return -1
        return 0

      result.push "round " + round + " totalMatches " + roundTotal + ' unavailable ' + unavailable.length + " AnyDates " + Object.keys(datescount).length + " forgotten " + forgotten.length
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
