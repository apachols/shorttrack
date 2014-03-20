class Round
  constructor: (roundnumber) ->
    @seat = 0
    @total = 0
    @daters = []
    @roundnumber = roundnumber

  # can error check here if we already have daters.  should not!
  addDate: (user1, user2) ->
    @total++
    @daters.push user1, user2

  # returns true if dater did not participate this round
  includes: (user) ->
    -1 isnt @daters.indexOf user

  nextSeat: -> ++@seat

  number: -> @roundnumber

class People
  constructor: () ->
    @personhash = {}
    @personlist = []

  addDate: (user1, user2) ->
    @add user1 if !personhash[user1]
    @add user2 if !personhash[user2]

    @personhash[user1].datescount++
    @personhash[user2].datescount++

  add: (user, arity) ->
    @personhash[user] = {arity, datescount: 0}
    @personlist.push user

  # sort the keylist from people by arity
  aritySort: (left, right) ->
    return -1 if @personhash[left].arity < @personhash[right].arity
    return  1 if @personhash[left].arity > @personhash[right].arity
    return  0

  print: ->
    # print information on people in order of arity
    for person in @personlist.sort @aritySort
      console.log 'arity', personhash[person].arity, 
      'datescount', personhash[person].datescount,
      'person', person
    return

class GreedyStrategy
  constructor: () ->

  # sort people by whether they were forgotten, with forgotten people on top
  postSort: (matches, people, round) ->

    matches.sort (left, right) ->
      sumleft =   not round.includes left.user1
      sumleft +=  not round.includes left.user2
      sumright =  not round.includes right.user1
      sumright += not round.includes right.user2

      return  1 if sumleft < sumright
      return -1 if sumleft > sumright
      return 0

  # are we ready to schedule this match?
  # also this will check here to see if this user needs a break
  pickMatch: (round, match) ->
    not round.includes match.user1 and 
    not round.includes match.user2

  # assume matches array is changed by reference here
  schedule: (matches, people, round) ->

    for match in matches

      if not match.round 

        if @pickMatch round, match

          people.addDate match.user1, match.user2
          round.addDate match.user1, match.user2

          match.round = round.number()
          match.seat = round.nextseat()

    @postSort matches

module.exports = GreedyStrategy

# this is the new face of Scheduler.coffee
execute = (matches, maxrounds) ->
  strategy = new GreedyStrategy
  people = new People

  while true

    round = new Round ++roundnumber

    matches = strategy.schedule people, matches, round

    do round.print

    break if !round.total or roundnumber > maxrounds

  do people.print

  matches
