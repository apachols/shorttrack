MeetupModel = require '../../src/models/meetup'
_ = require "lodash"

shuffle = require '../../src/lib/shuffle'

GreedyStrategy = require './greedyStrategy'
People = require './people'
Round = require './round'

class Scheduler
  constructor: (meetup) ->
    @meetup = meetup
    @errors = []

  execute: (callback) ->
    @getMatches (err, matches) =>
      callback err, null if err
      @scheduleRounds matches, callback

  executeGreedyStrategy: (matches, maxrounds) ->
    strategy = new GreedyStrategy
    people = new People
    roundnumber = 1

    # this duplicates a function in People.coffee, DRY...
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
