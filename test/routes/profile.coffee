# Requirements for testing
require 'should'

req = res = app =
  get: ->
  all: ->
  post: ->

# Test route
Profile = require('../../src/routes/profile') app

describe 'src/routes/profile.coffee', ->
  describe 'setup', ->
    it 'should pass an object of overrides to res.locals'
    it 'should run next()'

  describe 'auth', ->
    it 'should be rewritten to keep DRY :/',

  describe 'get', ->
    it 'should request an async.parallel object'
    it 'should get genders from the async results'
    it 'should render the profile page'

  describe 'update', ->
    it 'should update the user profile'
    it 'should save the user'
    it 'should send 400 if err'
    it 'should send 200 if success'
