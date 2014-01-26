Main = require('../src/routes/main') {get: ->}
require 'should'

describe 'Main', ->
  req = res = {}

  beforeEach ->
    req =
      logout: ->

    res =
      redirect: ->
      render: ->

  describe 'index', ->
    it 'should display a welcome message', (done) ->
      res.render = (view, vars) ->
        view.should.equal 'index'
        done()

      Main.index req, res

  describe 'logout', ->
    it 'should call req.logout', (done) ->
      req.logout = ->
        done()

      Main.logout req, res

    it 'should redirect to /', (done) ->
      res.redirect = (location) ->
        location.should.equal '/'
        done()

      Main.logout req, res
