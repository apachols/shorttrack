mongoose = require 'mongoose'

mongoose.connect(
  'mongodb://adam:password1220@dbh76.mongolab.com:27767/openspeeddating'
)

BlossomScheduler = require '../../../src/lib/Blossom'

b = new BlossomScheduler()

testGetMatches = (next) ->
  b.getMatches (err, matches) ->
    console.error err if err
    b.constructGraph matches, (err, result) -> 
      console.dir Object.keys(result)
      console.dir result.roster

      for row in result.matrix
        print = ""
        for entry in row
          print += " " + entry
        console.log print

      next()

testGetMatches () ->
  console.log 'Test Blossom Complete'
