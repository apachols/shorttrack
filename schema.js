var mongoose = require('mongoose');

var Schema = mongoose.Schema;

exports.UserSchema = new Schema({
    email: String,
    password: String
});

exports.GenderSchema = new Schema({
    label: String,
    code: String
});

exports.ProfileSchema = new Schema({



});

    // label: { type: String, default: null },
    // question: String,
    // answers: [{
    //     label: { type: String, default: null },
    //     answer: String
    // }],
    // correct: String