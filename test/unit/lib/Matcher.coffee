# Requirements for testing
require 'should'
gently = new(require 'gently')

Matcher = require '../../../src/lib/Matcher'
MatchModel = require '../../../src/models/Match'
MeetupModel = require '../../../src/models/Meetup'

describe 'src/lib/Matcher.coffee', ->

  testMeetup =
    name: 'blah'
    matches: [1,2,3]

  describe 'execute', ->
    it 'should callback with error if error', (done) ->
      done()

    it 'should call generateMatches with users and callback', (done) ->
      done()

  describe 'getUsers', ->
    it 'should call UserModel.find; callback returns users', (done) ->
      done()

  describe 'generateMatches', ->
    it 'should call @okToMatch on all combinations', (done) ->
      done()

    it 'should call @score on on all okToMatch combinations', (done) ->
      done()

    it 'should call MatchModel.create on all matches', (done) ->
      done()

  describe 'okToMatch', ->
    it 'should create an error if left okToMatch throws error', (done) ->
      done()

    it 'should create an error if right okToMatch throws error', (done) ->
      done()

    it 'should return true if left and right okToMatch', (done) ->
      done()

  describe 'score', ->
    it 'should create an error if left computeScore throws error', (done) ->
      done()

    it 'should create an error if right computeScore throws error', (done) ->
      done()

    it 'should create an error if count(in common) != for s1 & s2', (done) ->
      done()

    it 'should return the results of the score formula', (done) ->
      done()

  describe 'clearMatches', ->
    it 'should update the meetup with cleared matches', (done) ->
      m = new Matcher(testMeetup)
      e = {'fake' : 'error'}

      gently.expect MeetupModel, 'findOneAndUpdate',
      (findSpec, updateSpec, callback) ->
        callback e, testMeetup

      m.clearMatches (err, count) ->
        err.should.equal e
        count.should.equal 3
        done()

  describe 'getErrors', ->
    it 'should return @errors', (done) ->
      done()

  describe 'createError', ->
    it 'should return error w/ right & left users and message', (done) ->
      done()

    it 'should put in null for email if user objects are not ok', (done) ->
      done()
