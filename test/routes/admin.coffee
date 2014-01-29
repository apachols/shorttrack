# Requirements for testing
should = require 'should'
util = require 'util'
gently = new(require 'gently')

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

      Admin.auth req, res, next

    it 'should run next() when authenticated', (done) ->
      req.isAuthenticated = -> true

      Admin.auth req, res, done

  describe '#get /admin/user', ->
    it 'should return 400 if errors', (done) ->

      dummyErrors = [{"errcode" : "error message"}]

      req.validationErrors = -> dummyErrors

      next = ->
        should.fail 'do not call next if errors'

      res.redirect = (code, location) ->
        req.session.errors.should.equal util.inspect dummyErrors
        location.should.equal '/admin'
        code.should.equal 400
        done()

      Admin.user req, res, next

    it 'should call User.findUserByEmail with showUser as callback if no errors', (done) ->
      req.validationErrors = -> false

      req.params =
        email: 'test@test.com'

      gently.expect Admin, 'findUser', (email, callback) ->
        email.should.equal 'test@test.com'
        callback.should.equal Admin.showUser
        done()

      next = ->

      Admin.user req, res, next