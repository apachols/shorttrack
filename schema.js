var mongoose = require('mongoose');

var Schema = mongoose.Schema;

var passportLocalMongoose = require('passport-local-mongoose');

var User = new Schema({
    email: String,
    password: String
}, { collection: 'user' });

User.plugin(passportLocalMongoose);

module.exports.User = User;

module.exports.GenderSchema = new Schema({
    label: String,
    code: String
}, { collection: 'gender' });

// exports.ProfileSchema = new Schema({
// });

    // label: { type: String, default: null },
    // question: String,
    // answers: [{
    //     label: { type: String, default: null },
    //     answer: String
    // }],
    // correct: String