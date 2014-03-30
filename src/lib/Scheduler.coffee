MeetupModel = require '../../src/models/Meetup'
_ = require "lodash"

shuffle = require '../../src/lib/shuffle'

GreedyStrategy = require './GreedyStrategy'
People = require './People'
Round = require './Round'

# Maybe the way to make this testable is to have an
# round object be responsible for all stats tracking in a round
# scheduler object: stats tracking in a schedule (that aren't in a round)
# strategy object
#
# Do round
#     for all matches
#     if schedule.pick(match)
#       schedule.update(match)
#
# Program in breaks for popular people (from meetup record)
# Round limit (from meetup record)

class Scheduler
  constructor: (meetup) ->
    @meetup = meetup
    @errors = []

  execute: (callback) ->
    @getMatches (err, matches) =>
      callback err, null if err
      @scheduleRounds matches, callback

  # this is the new face of Scheduler.coffee
  executeGreedyStrategy: (matches, maxrounds) ->
    strategy = new GreedyStrategy
    people = new People
    roundnumber = 1

    # this duplicates a function in People.coffee, DRY brah
    matches = matches.sort (a,b)->
      return -1 if a.arity < b.arity
      return 1 if a.arity > b.arity
      return 0

    while true
      round = new Round roundnumber++

      matches = strategy.schedule matches, people, round

      do round.print

      break if !round.total or roundnumber > maxrounds

    do people.print

    matches

module.exports = Scheduler
