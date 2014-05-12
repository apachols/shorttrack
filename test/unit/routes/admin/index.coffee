# Requirements for testing
should = require 'should'
util = require 'util'
gently = new(require 'gently')

# Set up mock objects for express
req =
res =
app =
  all: ->
  get: ->
  post: ->

# Test route
UserModel = require '../../../../src/models/user'
Admin = require('../../../../src/routes/admin') app

# Test suite
describe 'src/routes/admin.coffee', ->

  describe 'auth', ->
    it 'should run next() when authenticated', (done) ->
      req.isAuthenticated = -> true
      req.user =
        admin: true

      Admin.auth req, res, done

    it 'should send an error when not authenticated', (done) ->
      req.isAuthenticated = -> false

      gently.expect res, 'send', (code, message) ->
        code.should.equal(401)
        message.should.equal('boo-urns')
        done()

      Admin.auth req, res, done


