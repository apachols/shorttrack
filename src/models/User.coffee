mongoose = require 'mongoose'

passportLocalMongoose = require 'passport-local-mongoose'

Profile = require './Profile'

User = new mongoose.Schema {
  email: String
  profile: [Profile.schema]
}, {
  collection: 'user'
  strict: false
}

User.plugin passportLocalMongoose, {
  usernameField: "email"
}

module.exports = mongoose.model 'User', User
