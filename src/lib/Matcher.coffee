UserModel = require '../../src/models/User'
MatchModel = require '../../src/models/Match'
QuestionModel = require '../../src/models/Question'

class Matcher
  constructor: (meetup) ->
    @meetup = meetup

  # really, we'll need to take a meetup here.  maybe in constructor
  execute: (callback) ->
    users = @getUsers(@meetup)
    @generateMatches(users)
    callback()

  # find all users registered for this meetup
  getUsers: () ->
    # @meetup.getRegisteredUsers()
    UserModel.find {}, (err, users)->
      console.log 'WUT'
      console.dir err if err
      console.dir users

  # returns list of matches in memory
  generateMatches: (users) ->
    matches = []
    while users.length
      left = users.pop()
      iter = users.length

      while iter--
        right = users[iter]
        if @okToMatch left, right
          score = @score left, right
          matches.push @createMatch left, right, score

    return matches

  createMatch: (left, right, score) ->

  okToMatch: (left, right) ->

  score: (left, right) ->

  # remove all matches from the DB
  clearMatches: () ->

module.exports = Matcher
