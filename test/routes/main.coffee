# Requirements for testing
require 'should'

# Mock app
app = {
  get: ->
}

# Test route
Main = require('../../src/routes/main') app

# Test suite
describe 'src/routes/main.coffee', ->
  req = res = {}

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
    it 'should display a welcome message', (done) ->
      res.render = (view, vars) ->
        view.should.equal 'index'
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
