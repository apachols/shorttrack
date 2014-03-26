class Round
  constructor: (roundnumber) ->
    @seat = 0
    @total = 0
    @daters = []
    @roundnumber = roundnumber

  # can error check here if we already have daters.  should not!
  addDate: (match) ->
    @total++
    @daters.push match.user1, match.user2

  # returns true if dater did not participate this round
  includes: (user) ->
    -1 isnt @daters.indexOf user

  nextSeat: -> ++@seat

  number: -> @roundnumber

  print: ->
    console.log "round", @roundnumber,
    "totalMatches", @total,
    "daters", @daters.length

module.exports = Round
