angular.module 'sting.meetups', ['ngResource', 'ngRoute']
.controller 'upcoming', ($scope, $resource, meetupService) ->
  $scope.$on 'addMeetup', (emitted, meetup) ->
    $scope.meetups.push meetup

  meetupService.setDocument null
  $resource('/api2/meetups/').query (meetups) ->
    $scope.meetups = meetups

.controller 'meetup', ($scope, $resource, $routeParams, meetupService, $http) ->
  {id} = $routeParams
  $scope.registered = false
  $resource('/api/meetup/:id', {id}).get (response) ->
    meetup = response.meetup
    $scope.meetup = meetup
    $scope.registered = !!response.registered
    $scope.canRegister = not (meetup.paid.length or meetup.matches.length)
    meetupService.setDocument $scope.meetup

  $scope.unregister = ()->
    $http.get("/api/unregister/#{id}")
      .success (response) ->
        console.log 'Unregister', response
        $scope.registered = false
        return
      .error (response) ->
        console.error 'Unregister', response

  $scope.register = ()->
    $http.get("/api/register/#{id}")
      .success (response) ->
        console.log 'Register', response
        $scope.registered = true
        return
      .error (response) ->
        console.error 'Register', response

.controller 'meetupCommands', ($scope, $location, meetupService, $http) ->

  $scope.view = () ->
    meetup = meetupService.getDocument(meetup)
    $location.path "/meetup/#{meetup._id}"

  $scope.generate = () ->
    meetup = meetupService.getDocument(meetup)
    $http.get("/api/generate/#{meetup._id}/").success (response) ->
      console.log 'GENERATE CALLBACK', response

  $scope.userlist = () ->
    meetup = meetupService.getDocument(meetup)
    $location.path "/meetup/#{meetup._id}/userlist"

  $scope.fullschedule = () ->
    meetup = meetupService.getDocument(meetup)
    $location.path "/meetup/#{meetup._id}/fullschedule"

.factory "meetupService", ($rootScope) ->
  record = null
  return {
    haveDocument: () -> record?

    getDocument: () ->
      console.log 'PACHOLSKI GET'
      return record

    setDocument: (doc) ->
      record = doc
      $rootScope.$broadcast 'meetupSelected', record
 }

.controller 'fullschedule', ($scope, $resource, $routeParams) ->
  {id} = $routeParams

  $resource('/api/fullschedule/:id', {id}).get (response) ->
    $scope.dates = response.dates

.directive 'userSchedule', ($resource, $routeParams)->
  restrict: 'E'
  templateUrl: '/public/templates/meetups/userschedule.html'
  link: ($scope, elem, attrs) ->
    $scope.rounds = []
    meetupId = attrs.meetupId || $routeParams.id

    console.log meetupId
    if meetupId?
      $resource('/api/userschedule/:meetupId', {meetupId}).get (response) ->
        $scope.rounds = response.rounds
        for R in $scope.rounds
          R.vote = "meh" unless R.vote

    $scope.vote = (round)->
      if round.vote == 'meh'
        round.vote = 'plz'
      else if round.vote == 'plz'
        round.vote = 'bai'
      else if round.vote == 'bai'
        round.vote = 'meh'

      id = round.partner.userid
      vote = round.vote
      $resource('/profile/vote/:id/:vote', {id, vote}).save()

.controller 'userlist', ($scope, $resource, $routeParams) ->
  {id} = $routeParams

  dbPaid = []

  $scope.paid = {}

  $scope.togglePaid = (doc) ->
    $scope.paid[doc._id]=!$scope.paid[doc._id]
    if ($scope.paid[doc._id])
      dbPaid.push doc._id
    else
      _.pull dbPaid, doc._id
    console.log dbPaid, $scope.paid

    paid = dbPaid
    $resource('/api2/meetups/:id', {id}).save {paid}, (response) ->
      console.log response

  $resource('/api/userlist/:id', {id}).get (response) ->
    $scope.registered = response.registered
    dbPaid = response.paid
    $scope.paid[uid] = true for uid in dbPaid

.controller 'meetupModal', ($scope, $modal, $resource) ->
  $parent = $scope.$parent

  modalController = ($scope, $resource, $modalInstance, $rootScope) ->

    rmMeetup = (meetup) ->
      for m, i in $parent.meetups
        if angular.equals meetup, m
          $parent.meetups.splice i, 1
          break

      delete $scope.meetup

    modalClose = (reason) ->
      console.log 'close', reason

      $scope.meetup.saved = true
      $resource("/api2/meetups/#{$scope.meetup._id}").save $scope.meetup, (meetup) ->
        $rootScope.$broadcast 'addMeetup', meetup

    modalDismiss = (reason) ->
      console.log 'dismiss', reason

      # Only delete the modal if it's never been saved, or
      # if we're requesting deletion.
      if (!$scope.meetup.saved) or reason is 'delete'
        $resource("/api2/meetups/#{$scope.meetup._id}").delete()
        rmMeetup $scope.meetup

    $scope.minDate = new Date()
    $scope.delete = -> $modalInstance.dismiss('delete')
    $scope.cancel = -> $modalInstance.dismiss()
    $scope.save = -> $modalInstance.close()

    $modalInstance.result.then modalClose, modalDismiss

  $scope.open = ->
    # Create a new meetup with all the defaults if there's not currently a
    # meetup in scope.
    unless $scope.meetup
      $resource('/api2/meetups').save {name: ''}, (meetup) ->
        $scope.meetup = meetup

    modalInstance = $modal.open
      scope: $scope
      templateUrl: '/public/templates/meetups/modal.html'
      controller: modalController

.directive 'meetup', ->
  restrict: 'E'
  templateUrl: '/public/templates/meetups/meetup.html'
  link: ($scope, elem, attrs) ->
    $scope["#{attrs.view}View"] = true
