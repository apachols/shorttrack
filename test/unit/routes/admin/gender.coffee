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
GenderModel = require '../../../../src/models/Gender'
Gender = require('../../../../src/routes/admin/gender') app

# Test suite
describe 'src/routes/gender.coffee', ->

  describe 'gender', ->
    it 'should 404 without a valid gender', (done) ->
      req.params =
        code: 'X'

      gently.expect GenderModel, 'findOne', (findSpec, callback) ->
        callback('Gender not found', null)

      gently.expect req, 'flash', (type, message) ->
        type.should.equal 'error'

      gently.expect res, 'redirect', (route) ->
        route.should.equal '/admin'
        done()

      Gender.gender req, res, ->

    it 'should render the admin/gender view', (done) ->
      req.params =
        code: 'F'

      gender =
        label: 'Female'
        code: 'F'

      gently.expect GenderModel, 'findOne', (findSpec, callback) ->
        findSpec.code.should.equal 'F'
        callback(null, gender)

      gently.expect res, 'render', (route, object) ->
        route.should.equal('admin/gender')
        object.gender.should.equal(gender)
        done()

      Gender.gender req, res, ->
