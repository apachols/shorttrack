mongoose = require 'mongoose'

passportLocalMongoose = require 'passport-local-mongoose'

User = new mongoose.Schema {
    email: String
}, {
    collection: 'user'
}

User.plugin passportLocalMongoose, {
    usernameField: "email"
}

module.exports = mongoose.model 'User', User
