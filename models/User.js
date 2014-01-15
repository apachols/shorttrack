var mongoose = require('mongoose');

var passportLocalMongoose = require('passport-local-mongoose');

var User = new mongoose.Schema({
    email: String
}, { collection: 'user' });

User.plugin(passportLocalMongoose);

module.exports = mongoose.model('User', User);
