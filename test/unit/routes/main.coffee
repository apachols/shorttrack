# Requirements for testing
require 'should'
gently = new(require 'gently')

# Mock app
req =
res =
app =
  get: ->
  post: ->
  put: ->
  delete: ->

# Test route
MeetupModel = require '../../../src/models/meetup'
Main = require('../../../src/routes/main') app

# Test suite
describe 'src/routes/main.coffee', ->

  beforeEach ->
    req =
      logout: ->
      user: 'test'

    res =
      locals: ->
      redirect: ->
      render: ->

  describe '#get *', ->
    it 'should set up common vars for all routes', (done) ->
      res.locals = (args) ->
        args.brand.should.equal 'Homepage'
        args.my.should.equal 'test'
        done()

      Main.setup req, res, ->

  describe '#get /index', ->
    xit 'should display error if error', (done) ->
      fakeerror = "everything is wrong"
      fakequery = {}
      gently.expect MeetupModel, 'find', (arg1) ->
        fakequery

      gently.expect fakequery, 'sort', (arg1) ->
        fakequery

      gently.expect fakequery, 'find', (callback) ->
        callback fakeerror, null

      res.send = (code, error) ->
        code.should.equal 500
        error.should.equal.fakeerror
        done()

      Main.index req, res

    xit 'should display meetups if found', (done) ->
      fakemeetups = [{},{}]
      fakequery = {}
      gently.expect MeetupModel, 'find', (arg1) ->
        fakequery

      gently.expect fakequery, 'sort', (arg1) ->
        fakequery

      gently.expect fakequery, 'find', (callback) ->
        callback null, fakemeetups

      res.render = (view, meetups) ->
        view.should.equal 'index'
        meetups.should.equal.fakemeetups
        done()

      Main.index req, res


  describe '#get /logout', ->
    it 'should call req.logout', (done) ->
      req.logout = ->
        done()

      Main.logout req, res

    it 'should redirect to /', (done) ->
      res.redirect = (location) ->
        location.should.equal '/'
        done()

      Main.logout req, res
