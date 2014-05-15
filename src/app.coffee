if process.env.NODE_ENV is 'staging'
  domain = 'localhost'
  appPort = 3000
  process.env.NODE_ENV = 'production'

cson = require 'season'
express = require 'express'
validator = require 'express-validator'
flash = require 'express-flash'
util = require 'util'
path = require 'path'
harp = require 'harp'
tp = require 'tea-properties'
df = require 'dateformat'

# Passport
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy

# Mongodb
mongoose = require 'mongoose'
Mongostore = require('connect-mongostore') express

# Initalize app
app = express()

app.configure ->
  {username, password, host, port, store, secret} =
    cson.readFileSync "#{__dirname}/../config.cson"

  mongoose.connect "mongodb://#{username}:#{password}@#{host}:#{port}/#{store}"

  session_settings =
    secret: 'To live and die in LA'
    maxAge: new Date Date.now() + 3600000
    store: new Mongostore
      'db': mongoose.connection.db, (err) ->
        console.log err or 'connect-mongodb setup ok'

  middleware = [
    express.favicon()
    express.logger 'dev'
    express.json()
    express.urlencoded()
    validator()
    express.methodOverride()
    express.cookieParser(secret)
    express.session session_settings
    passport.initialize()
    passport.session()
    flash()
    app.router
  ]

  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'

  app.use m for m in middleware

  # app.use '/public', express.static path.resolve __dirname, '../public'
  app.use '/public', harp.mount path.resolve __dirname, '../public'
  app.use 'favicon', path.resolve __dirname, '../public/favicon.ico'

  app.locals
    get: (obj, loc, def = undefined) -> tp.get(obj, loc) ? def
    inspect: util.inspect
    df: df

app.configure 'development', ->
  app.use express.errorHandler {dumpExceptions: true, showStack: true}
  app.locals.pretty = true
  app.set 'domain', 'localhost'
  app.set 'port', 3000

app.configure 'production', ->
  app.set 'domain', (domain ?= 'shorttrack.me')
  app.set 'port', (appPort ?= 80)

User = require('./models/user')
passport.use User.createStrategy()
passport.serializeUser User.serializeUser()
passport.deserializeUser User.deserializeUser()

require('./routes') app

app.listen (app.get 'port'), (app.get 'domain')
console.log "Listenting to #{app.get 'domain'}:#{app.get 'port'}"

module.exports = app
