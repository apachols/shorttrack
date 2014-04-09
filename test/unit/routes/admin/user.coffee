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
User = require('../../../../src/routes/admin/user') app

# Test suite
describe 'src/routes/user.coffee', ->

  describe 'validate', ->
    it 'should run next() if there are no errors', (done) ->
      req.isEmail = ->
      req.assert = -> return req

      req.validationErrors = -> false

      User.validate req, res, done

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
      User.validate req, res, next

  describe 'user', ->
    it 'should 404 without a valid user', (done) ->
      req.params =
        email: 'test@lame.wut'

      gently.expect UserModel, 'findOne', (findSpec, callback) ->
        findSpec.email.should.equal 'test@lame.wut'
        callback 'User not found', null

      gently.expect req, 'flash', (type, message) ->
        type.should.equal 'error'

      gently.expect res, 'redirect', (route) ->
        route.should.equal '/admin'
        done()

      User.user req, res, ->

    it 'should render the admin/user view', (done) ->
      req.params =
        email: 'test@lame.wut'

      user =
        email: 'test@lame.wut'

      gently.expect UserModel, 'findOne', (findSpec, callback) ->
        findSpec.email.should.equal 'test@lame.wut'
        callback null, user

      gently.expect res, 'render', (route, object) ->
        route.should.equal 'admin/user'
        object.user.should.equal user
        done()

      User.user req, res, ->


