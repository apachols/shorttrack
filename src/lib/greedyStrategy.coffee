class GreedyStrategy
  constructor: () ->

  # overrideable by child class using different strategy
  sortMatchesOnRoundComplete: (matches, round) ->
    @sortForgottenToTheFront matches, round

  # sort people by whether they were forgotten, with forgotten people on top
  sortForgottenToTheFront: (matches, round) ->

    matches.sort (left, right) ->
      sumleft =   not round.includes left.user1.email
      sumleft +=  not round.includes left.user2.email
      sumright =  not round.includes right.user1.email
      sumright += not round.includes right.user2.email

      return  1 if sumleft < sumright
      return -1 if sumleft > sumright
      return 0

  # are we ready to schedule this match?
  # also this will check here to see if this user needs a break
  pickMatch: (round, match) ->
    return false if round.includes(match.user1.email)
    return false if round.includes(match.user2.email)
    return true

  # assume matches array is changed by reference here
  schedule: (matches, people, round) ->

    for match in matches

      if ! match.round and @pickMatch round, match

        people.addDate match
        round.addDate match

        match.round = round.number()
        match.seat = round.nextSeat()

    @sortMatchesOnRoundComplete matches, round

module.exports = GreedyStrategy
