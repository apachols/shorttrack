# Requirements for testing
should = require 'should'

req =
res =
app =
  get: ->
  all: ->

# Test route
Admin = require('../../src/routes/admin') app

# Test suite
describe 'src/routes/admin.coffee', ->
  # req = res = {}

  beforeEach ->
    req =
      isAuthenticated: ->
      validationErrors: ->
      session: {}
      user: 'test'

    res =
      render: ->
      send: ->
      redirect: ->

  describe '#all ^/auth', ->
    it 'should return a 401 without authentication', (done) ->
      req.isAuthenticated = ->
        false

      res.send = (message, code) ->
        message.should.be.type 'string'
        code.should.equal 401
        done()

      next = ->
        should.fail 'do not call next unless authenticated'
        done()

      Admin.auth req, res, next

    it 'should run next() when authenticated', (done) ->
      req.isAuthenticated = -> true

      Admin.auth req, res, done

  describe '#get /admin/user', ->

