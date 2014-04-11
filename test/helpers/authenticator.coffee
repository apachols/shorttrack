should = require 'should'
gently = new(require 'gently')
auth   = require '../../src/helpers/authenticator'
req    = {}
res    = {}

describe 'src/helpers/authenticator', ->


  describe 'user', ->
    it 'should run next() for any user', (next) ->
      req.isAuthenticated = -> true

      auth.user req, res, next


    it 'should fail for any non user', (done)->
      req.isAuthenticated = -> false

      gently.expect res, 'send', (code) ->
        code.should.equal 401
        do done

      auth.user req, res, ->


  describe 'admin', ->
    it 'should run next() for admins', (next) ->
      req.isAuthenticated = -> true
      req.user =
        admin: true

      auth.admin req, res, next

    it 'should fail for everyone else', (done) ->
      delete req.user.admin

      gently.expect res, 'send', (code) ->
        code.should.equal 401
        do done

      auth.admin req, res, ->



