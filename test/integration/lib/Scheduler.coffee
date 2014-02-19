mongoose = require 'mongoose'

mongoose.connect(
  'mongodb://adam:password1220@dbh76.mongolab.com:27767/openspeeddating'
)

Scheduler = require '../../../src/lib/Scheduler'

s = new Scheduler()

testGetMatches = (next) ->
  s.getMatches (err, matches) ->
    console.error err if err
    s.scheduleRounds matches, (err, result) -> 
      console.log result.length + ' rounds'
      for r in result
        console.dir r
      next()

# testScheduleRounds = (next) ->
#   s.execute (err, count) ->
#     console.error err if err
#     console.log 'Created ' + count + ' matches'
#     next()

testGetMatches () ->
  console.log 'Test Schedule Rounds Complete'
