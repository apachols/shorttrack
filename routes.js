var passport = require('passport'),
    User = require('./models/User');

module.exports = function (app) {
    app.get('/', function (req, res) {
        res.render('index', { "user" : req.user });
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


    require('coffee-script');
    var admin = require('./routes/admin')
    app.get('/admin', admin.home)

    app.get('/login', function(req, res) {
        res.render('login', { "user" : req.user });
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
