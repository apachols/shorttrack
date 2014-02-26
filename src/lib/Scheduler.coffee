MatchModel = require '../../src/models/Match'
_ = require "lodash"

shuffle = require '../../src/lib/shuffle'

# Maybe the way to make this testable is to have an object be responsible for all stats tracking
#   for all matches
#     if schedule.pick(match)
#       schedule.update(match)
#
# Next refactor:  put all this stuff inside of meetup
#
# If we implement the other algorithm too, it may not be easy to do it this way
# But we can definitely do different versions of greedy!  Perfect.
#
# how do we get individual schedules out of here?
#     meetup.getSchedule(user)
#       pull all meetups for user by round
#       insert blanks for user
# how do we get entire schedule?
#     meetup.getSchedule()
#       pull all meetups by round
#       display organized by round

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
      # shuffle.shuffle(matches)
      callback err, matches

  scheduleRounds: (matches, callback) ->
    # value returned to caller - right now full of gooey debug info
    result = []

    # statistics on all participants in this schedule
    personlog = {}

    round = 1
    while true
      console.error 'ROUND ' + round + ': FIGHT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
      roundTotal = 0

      # list of match records to tag as being part of this round (match.round = round)
      toUpdate = []

      # list of people participating in this round
      unavailable = []

      for match in matches
        # set up stats logging for player 1
        if personlog[match.user1]
          person1 = personlog[match.user1]
        else
          person1 = personlog[match.user1] =
            arity: match.arity.user1
            datescount: 0
        # set up stats logging for player 2
        if personlog[match.user2]
          person2 = personlog[match.user2]
        else
          person2 = personlog[match.user2] =
            arity: match.arity.user2
            datescount: 0

        if !match.round

          okUser1 = -1 == unavailable.indexOf match.user1
          okUser2 = -1 == unavailable.indexOf match.user2
          if okUser1 and okUser2

            # stats!
            roundTotal++
            person1.datescount++
            person2.datescount++

            # make these people unavailable for this round, they are on a date
            unavailable.push match.user1, match.user2

            # make sure to update this match record with match.round = round
            toUpdate.push match._id
            # temporary - while we are entirely in memory we need this
            match.round = round

      # sort the list again by arity descending - seems to perform almost as well as forgotten->top
      # matches.sort (left, right) ->
      #   if left.arity.total > right.arity.total
      #     return 1
      #   if left.arity.total < right.arity.total
      #     return -1
      #   return 0

      # calculate who sat out during this round
      forgotten = _.difference Object.keys(personlog), _.uniq unavailable

      # sort by whether they were forgotten, with forgotten people on top
      matches.sort (left, right) ->
        sumleft = (-1 != forgotten.indexOf(left.user1)) + (-1 != forgotten.indexOf(left.user2))
        sumright = (-1 != forgotten.indexOf(right.user1)) + (-1 != forgotten.indexOf(right.user2))
        if sumleft < sumright
          return 1
        if sumleft > sumright
          return -1
        return 0

      result.push "round " + round + " totalMatches " + roundTotal + ' unavailable ' + unavailable.length + " forgotten " + forgotten.length
      round++

      # while number added during last round > 0
      break if !roundTotal or round > 4

    # Display all of our participants at the end of scheduling
    personarray = Object.keys(personlog).sort (left, right) ->
      if personlog[left].arity < personlog[right].arity
        return -1
      if personlog[left].arity > personlog[right].arity
        return 1
      return 0

    for person in personarray
      console.log 'arity', personlog[person].arity, 'datescount', personlog[person].datescount, 'person', person

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
