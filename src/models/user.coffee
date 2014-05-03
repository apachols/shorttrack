mongoose = require 'mongoose'

passportLocalMongoose = require 'passport-local-mongoose'

Profile = require './profile'
_ = require 'lodash'

User = new mongoose.Schema {
  admin: Boolean
  email: String
  resetToken: String
  tokenExpires: Date
  profile: [Profile.schema]
  relations: [ new mongoose.Schema {
    userid: String
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

# This is called in a loop!  Should instead return map/object
User.methods.relation = (userid) ->
  for person in @relations
    return person.status if person.userid is userid
  null

User.methods.relate = (userid, status, callback) ->
  index = (_.pluck @relations, 'userid').indexOf userid
  if -1 isnt index
    @relations[index].status = status
    @save callback
  else
    date = new Date()
    notify = 0
    @update
      $push:
        relations: {userid, status, date, notify}
    , callback

try module.exports = mongoose.model 'User', User
catch e then module.exports = mongoose.model 'User'
