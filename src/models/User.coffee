mongoose = require 'mongoose'

passportLocalMongoose = require 'passport-local-mongoose'

Profile = require './Profile'

User = new mongoose.Schema {
  email: String
  profile: [Profile.schema]
  relations: [ new mongoose.Schema {
    email: String
    status: String
    date: Date
    notify: Number
  }
  ]
}, {
  collection: 'user'
  strict: false
}

User.plugin passportLocalMongoose, {
  usernameField: "email"
}

# User.methods.like = (email, callback) ->
#   date = new Date()
#   query =
#     $push:
#       like: {email, date}
#     $pull:
#       unlike: {email}

#   User.findOneAndUpdate {email}, query, callback

# User.methods.unlike = (email, callback) ->
#   date = new Date()
#   query =
#     $push:
#       unlike: {email, date}
#     $pull:
#       like: {email}

#   User.findOneAndUpdate {email}, query, callback

module.exports = mongoose.model 'User', User
