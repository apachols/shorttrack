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
UserModel = require '../../src/models/User'
Admin = require('../../src/routes/admin') app

# Test suite
describe 'src/routes/admin.coffee', ->

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

  describe 'home', ->
    it 'should send a 500 error if error on users query', (done) ->
      gently.expect UserModel, 'find', (findSpec, callback) ->
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
      gently.expect UserModel, 'find', (findSpec, callback) ->
        callback(null, users)

      gently.expect res, 'render', (route, object) ->
        route.should.equal('admin/home')
        object.users.should.equal(users)
        done()

      Admin.home req, res, ->


