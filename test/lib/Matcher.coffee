mongoose = require 'mongoose'


mongoose.connect(
  'mongodb://adam:password1220@dbh76.mongolab.com:27767/openspeeddating'
)

Matcher = require '../../src/lib/Matcher'

m = new Matcher()

testClear = (next) ->
  console.log 'testClear'
  m.clearMatches (err, count) ->
    console.error err if err
    console.log 'Cleared ' + count + ' matches'
    next()

testExecute = (next) ->
  m.execute (err, count) ->
    console.error err if err
    console.log 'Created ' + count + ' matches'
    next()

testClear () ->
  testExecute () ->
    console.log 'Match calculation complete'
