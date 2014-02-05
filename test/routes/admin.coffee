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

      gently.expect req, 'flash', (errorMessage, errorList) ->
        errorMessage.should.equal 'error'
        errorList.should.equal util.inspect errors

      gently.expect res, 'redirect', (redirectRoute) ->
        redirectRoute.should.be.equal '/admin'
        done()

      next = ->
      Admin.validate req, res, next

  describe 'user', ->
    it 'should 404 without a valid user', (done) ->
      req.params =
        email: 'test@lame.wut'

      gently.expect User, 'findOne', (findSpec, callback) ->
        callback('User not found', null)

      gently.expect res, 'send', (code, message) ->
        code.should.equal(404)
        message.should.equal('User not found')
        done()

      Admin.user req, res, ->

    it 'should render the admin/user view', (done) ->
      req.params =
        email: 'test@lame.wut'

      user =
        email: 'test@lame.wut'

      gently.expect User, 'findOne', (findSpec, callback) ->
        callback(null, user)

      gently.expect res, 'render', (route, object) ->
        route.should.equal('admin/user')
        object.user.should.equal(user)
        done()

      Admin.user req, res, ->

  describe 'home', ->
    it 'should send a 500 error if error on users query', (done) ->
      gently.expect User, 'find', (findSpec, callback) ->
        callback('Error dude!', null)

      gently.expect res, 'send', (code, message) ->
        code.should.equal(500)
        message.should.equal('Error dude!')
        done()

      Admin.home req, res, ->

    it 'should render the admin/home view if no error on users query', (done) ->
      users = [
        {
          email: 'one@one.com'
        }
        {
          email: 'two@two.com'
        }
      ]
      gently.expect User, 'find', (findSpec, callback) ->
        callback(null, users)

      gently.expect res, 'render', (route, object) ->
        route.should.equal('admin/home')
        object.users.should.equal(users)
        done()

      Admin.home req, res, ->


