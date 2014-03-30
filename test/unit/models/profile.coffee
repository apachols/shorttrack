# Requirements for testing
require 'should'

# Mock app
req =
res =
app =
  get: ->
  all: ->
  post: ->

# Test route
profile = require('../../../src/routes/profile') app

# Test suite
describe 'src/routes/profile.coffee', ->

  beforeEach ->
    req =
      logout: ->
      user: 'test'

    res =
      locals: ->
      redirect: ->
      render: ->

  describe '#get *', ->
    it 'should do some things', ->
