
/**
 * Module dependencies.
 */

var express = require('express');
var routes = require('./routes');
var user = require('./routes/user');
var http = require('http');
var path = require('path');

var mongoose = require('mongoose'),
    passport = require('passport'),
    LocalStrategy = require('passport-local').Strategy;

var app = express();

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.json());
app.use(express.urlencoded());
app.use(express.methodOverride());

// app.use(express.static('public'));
app.use(express.cookieParser('your secret here'));
app.use(express.bodyParser());
app.use(express.session({ secret: 'keyboard cat' }));

app.use(passport.initialize());
app.use(passport.session());

app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));

app.configure('development', function(){
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
    app.use(express.errorHandler());
});

// Configure passport
var UserSchema = require('./schema').User;

var UserModel = mongoose.model('User', UserSchema);

passport.use(new LocalStrategy(UserModel.authenticate()));

passport.serializeUser(UserModel.serializeUser());
passport.deserializeUser(UserModel.deserializeUser());

// Connect mongoose
mongoose.connect('mongodb://localhost/passport_local_mongoose_examples');

// Setup routes
require('./routes')(app);

http.createServer(app).listen(3000, '127.0.0.1', function() {
    console.log("Express server listening on %s:%d in %s mode", '127.0.0.1', 3000, app.settings.env);
});
