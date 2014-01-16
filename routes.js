var passport = require('passport')
  , User = require('./models/User')
  , _ = require('lodash')
  ;



module.exports = function (app) {
    app.get('/', function (req, res) {
        res.locals.title = 'Homepage';
        res.render('index', { my : req.user });
    });

    app.get('/register', function(req, res) {
        res.render('register', { "username" : "" });
    });

    app.post('/register', function(req, res) {
        var newUser = new User({
            username : req.body.username
        });
        User.register(newUser, req.body.password, function(err) {
            if (err) {
                return res.render('register', {
                    "username" : req.body.username,
                    "errormessage" : err.message || "An error occurred"
                });
            }

            res.redirect('/');
        });
    });

    // Admin
    require('coffee-script');
    var admin = require('./routes/admin');
    app.get('/admin/:username', admin.user);
    app.get('/admin', admin.home);


    app.get('/login', function(req, res) {
        res.render('login', { my : req.user });
    });

    app.post('/login', passport.authenticate('local', {
            successRedirect: '/',
            failureRedirect: '/login'
    }));

//
// NOTE - custom callback like this:  http://passportjs.org/guide/authenticate/
//
// app.get('/login', function(req, res, next) {
//   passport.authenticate('local', function(err, user, info) {

    app.get('/logout', function(req, res) {
        req.logout();
        res.redirect('/');
    });
};
