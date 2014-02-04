# Requirements for testing
should = require 'should'
util = require 'util'
gently = new(require 'gently')

req =
res =
app =
  all: ->
  get: ->
  post: ->

# Test route
User = require '../../src/models/User'
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

  describe 'auth', ->
    it 'should run next() when authenticated', (done) ->
      req.isAuthenticated = -> true

      Admin.auth req, res, done

  describe 'validate', ->
    it 'should run next() if there are no errors', (done) ->
      req.isEmail = ->
      req.assert = -> return req

      req.validationErrors = -> false

      Admin.validate req, res, done

    it 'should redirect to admin if errors', (done) ->
      errors = [{"code", "message"}]

      req.isEmail = ->
      req.assert = -> return req
      req.validationErrors = -> errors

      next = ->

      gently.expect req, 'flash', (errorMessage, errorList) ->
        errorMessage.should.equal 'error'
        errorList.should.equal util.inspect errors

      gently.expect res, 'redirect', (redirectRoute) ->
        redirectRoute.should.be.equal '/admin'
        done()

      Admin.validate req, res, next

  describe 'user', ->
    it 'should 404 without a valid user'

    it 'should render the admin/user view'

  describe 'home', ->
    it 'should render the admin/home view'

  # describe '#get /admin/:email', ->
  #   it 'should return 400 if errors', (done) ->

  #     dummyErrors = [{"errcode" : "error message"}]

  #     req.validationErrors = -> dummyErrors

  #     next = ->
  #       should.fail 'do not call next if errors'

  #     res.redirect = (code, location) ->
  #       req.session.errors.should.equal util.inspect dummyErrors
  #       location.should.equal '/admin'
  #       code.should.equal 400
  #       done()

  #     Admin.user req, res, next

  #   it 'should call User.findUserByEmail with showUser as
  #   callback if no errors', (done) ->
  #     req.validationErrors = -> false

  #     req.params =
  #       email: 'test@test.com'

  #     gently.expect Admin, 'findUser', (email, callback) ->
  #       email.should.equal 'test@test.com'
  #       callback.should.equal Admin.showUser
  #       done()

  #     next = ->

  #     Admin.user req, res, next
