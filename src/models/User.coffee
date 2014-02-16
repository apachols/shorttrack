mongoose = require 'mongoose'

passportLocalMongoose = require 'passport-local-mongoose'

Profile = require './Profile'

User = new mongoose.Schema {
  email: String
  profile: [Profile.schema]
}, {
  collection: 'user'
  strict: 'throw'
}

User.plugin passportLocalMongoose, {
  usernameField: "email"
}

try module.exports = mongoose.model 'User', User
catch e then module.exports = mongoose.model 'User'
