# Express
express = require 'express'
validator = require 'express-validator'

# Passport
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy

# Mongodb
mongoose = require 'mongoose'
Mongostore = require('connect-mongostore') express

# Node
path = require 'path'
_ = require 'lodash'

# @todo hmmm...
mongoose.connect 'mongodb://adam:password1220@dbh76.mongolab.com:27767/openspeeddating'

# Initalize app
app = express()

middleware = [
  express.favicon()
  express.logger 'dev'
  express.json()
  express.urlencoded()
  express.methodOverride()
  express.cookieParser('wow, such secret')
  express.bodyParser()
  validator() # first after bodyParser
  express.session session_settings
  passport.initialize()
  passport.session()
  app.router
  express.static __dirname + '/bower_components'
]

session_settings =
  secret: 'To live and die in LA'
  maxAge: new Date Date.now() + 3600000
  store: new Mongostore
    'db': mongoose.connection.db
    , (err) ->
      console.log err or 'connect-mongodb setup ok'

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use m for m in middleware

app.configure 'development', ->
  app.use express.errorHandler {dumpExceptions: true, showStack: true}

app.configure 'production', ->
  app.use express.errorHandler()

User = require('./models/User')
passport.use User.createStrategy()
passport.serializeUser User.serializeUser()
passport.deserializeUser User.deserializeUser()

require('./routes') app

app.listen 3000, -> console.log 'OpenSpeedDating listening on port 3000'
