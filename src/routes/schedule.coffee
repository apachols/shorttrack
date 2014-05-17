MeetupModel = require '../models/meetup'
auth        = require '../helpers/authenticator'

class Schedule
  constructor: (@app) ->

    @app.get  '/schedule/:meetupid/:userid',@userSchedule
    @app.get  '/schedule/:meetupid', @fullSchedule

  userSchedule: (req, res) ->
    {meetupid, userid} = req.params
    MeetupModel.findOne { _id: meetupid }, (err, meetup) ->
      meetup.getScheduleUser userid, (matches) ->
        res.json {matches}

  fullSchedule: (req, res) ->
    {meetupid, userid} = req.params
    MeetupModel.findOne { _id: meetupid }, (err, meetup) ->
      meetup.getScheduleAll (matches) ->
        res.json {matches}

module.exports = (app) -> new Schedule app
