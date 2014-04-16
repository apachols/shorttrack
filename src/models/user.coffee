mongoose = require 'mongoose'

passportLocalMongoose = require 'passport-local-mongoose'

Profile = require './profile'
_ = require 'lodash'

User = new mongoose.Schema {
  admin: Boolean
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

# This is called in a loop!  Should instead return map/object
User.methods.relation = (email) ->
  for person in @relations
    return person.status if person.email is email
  null

User.methods.relate = (email, status, callback) ->
  index = (_.pluck @relations, 'email').indexOf email
  if -1 isnt index
    @relations[index].status = status
    @save callback
  else
    date = new Date()
    notify = 0
    @update
      $push:
        relations: {email, status, date, notify}
    , callback

try module.exports = mongoose.model 'User', User
catch e then module.exports = mongoose.model 'User'