MeetupModel = require '../../src/models/Meetup'
_ = require "lodash"

shuffle = require '../../src/lib/shuffle'

# Maybe the way to make this testable is to have an
# object be responsible for all stats tracking
#   for all matches
#     if schedule.pick(match)
#       schedule.update(match)
#
# how do we get individual schedules out of here?
#     meetup.getSchedule(user)
#       pull all meetups for user by round
#       insert blanks for user
#
# how do we get entire schedule?
#     meetup.getSchedule()
#       pull all meetups by round
#       display organized by round

class Scheduler
  constructor: (meetup) ->
    @meetup = meetup
    @errors = []

  execute: (callback) ->
    console.log '@execute'

    @getMatches (err, matches) =>
      console.log '@getUsers callback'
      callback err, null if err
      @scheduleRounds matches, callback

  # pull in all match records in order of
  getMatches: (callback) ->
    console.log '@getMatches'

    # shuffle.shuffle(@meetup.matches)
    callback @meetup.matches.sort (a,b)->
      return -1 if a.arity.total < b.arity.total
      return 1 if a.arity.total > b.arity.total
      return 0

  scheduleRounds: (matches, callback) ->
    # value returned to caller - right now full of gooey debug info
    result = []

    # statistics on all participants in this schedule
    personlog = {}

    round = 1
    while true
      console.error 'ROUND ' + round + ': FIGHT!!!!!!!!!!!!!!!!!!!!!!!'
      roundTotal = 0

      #
      # BEGIN GreedyStrategy.scheduleRound matches, round
      #

      # list of match records to tag as being part of this round
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

      #
      # END GreedyStrategy.scheduleRound
      #

      # calculate who sat out during this round
      forgotten = _.difference Object.keys(personlog), _.uniq unavailable

      #
      #
      #

      # sort by whether they were forgotten, with forgotten people on top
      matches.sort (left, right) ->
        sumleft =   (-1 != forgotten.indexOf(left.user1))
        sumleft +=  (-1 != forgotten.indexOf(left.user2))
        sumright =  (-1 != forgotten.indexOf(right.user1))
        sumright += (-1 != forgotten.indexOf(right.user2))
        if sumleft < sumright
          return 1
        if sumleft > sumright
          return -1
        return 0

      resultstr = "round " + round + " totalMatches " + roundTotal
      resultstr += ' unavailable ' + unavailable.length
      resultstr += " forgotten " + forgotten.length
      result.push resultstr
      round++

      # while number added during last round > 0
      break if !roundTotal # or round > 4, need to put round limiting on meetup

    # Display all of our participants at the end of scheduling
    personarray = Object.keys(personlog).sort (left, right) ->
      if personlog[left].arity < personlog[right].arity
        return -1
      if personlog[left].arity > personlog[right].arity
        return 1
      return 0

    for person in personarray
      console.log 'arity', personlog[person].arity, 'datescount',
      personlog[person].datescount, 'person', person

    MeetupModel.findOne
      name: @meetup.name
    , (err, meetup) ->
      console.log 'saving matches to the database'
      meetup.matches = matches
      meetup.save()
      callback null, result

module.exports = Scheduler

      # sort the list again by arity descending
      # matches.sort (left, right) ->
      #   if left.arity.total > right.arity.total
      #     return 1
      #   if left.arity.total < right.arity.total
      #     return -1
      #   return 0
