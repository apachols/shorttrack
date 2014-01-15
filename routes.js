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
        User.register(newUser, req.body.password, function(err, user) {
            if (err) {
console.error('AN ERROR OCCURRED');
console.dir(err);
                return res.render('register', {
                    "username" : req.body.username,
                    "errormessage" : err.message || "An error occurred"
                });
            }

            res.redirect('/');
        });
    });

    app.get('/login', function(req, res) {
        res.render('login', { "user" : req.user });
    });

    app.post('/login', passport.authenticate('local'), function(req, res) {
        res.redirect('/');
    });

    app.get('/logout', function(req, res) {
        req.logout();
        res.redirect('/');
    });
};
