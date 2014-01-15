var mongoose = require('mongoose');

var Gender = new mongoose.Schema({
    label: String,
    code: String
}, { collection: 'gender' });

module.exports = mongoose.model('Gender', Gender);