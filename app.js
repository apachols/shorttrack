var express = require('express')
  , routes = require('./routes')
  , user = require('./routes/user')
  , http = require('http')
  , path = require('path')
  , mongoose = require('mongoose')
  , passport = require('passport')
  , LocalStrategy = require('passport-local').Strategy
  , MongoStore = require('connect-mongostore')(express)
  , validator = require('express-validator')
  ;

// Connect mongoose
// mongoose.connect('mongodb://localhost/osd')
mongoose.connect('mongodb://adam:password1220@dbh76.mongolab.com:27767/openspeeddating');

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
app.use(validator());

// app.use(express.session({ secret: 'keyboard cat' }));

app.use(express.session({
    secret:'To live and die in LA',
    maxAge: new Date(Date.now() + 3600000),
    store: new MongoStore(
        {'db':mongoose.connection.db},
        function(err){
            console.log(err || 'connect-mongodb setup ok');
        })
}));

app.use(passport.initialize());
app.use(passport.session());

app.use(app.router);
app.use(express.static(path.join(__dirname, 'bower_components')));

app.configure('development', function(){
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
    app.use(express.errorHandler());
});

// Configure passport
var User = require('./models/User');

passport.use(new LocalStrategy(User.authenticate()));

passport.serializeUser(User.serializeUser());
passport.deserializeUser(User.deserializeUser());

// Setup routes
require('./routes')(app);

http.createServer(app).listen(3000, '127.0.0.1', function() {
    console.log("Express server listening on %s:%d in %s mode", '127.0.0.1', 3000, app.settings.env);
});
