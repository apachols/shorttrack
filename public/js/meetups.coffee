angular.module 'sting.meetups', ['ngResource', 'ngRoute']

.controller 'upcoming', ($scope, $resource) ->
  $resource('/api2/meetups/').query (meetups) ->
    $scope.meetups = meetups

.controller 'meetup', ($scope, $resource, $routeParams) ->
  {id} = $routeParams
  $resource('/api2/meetups/:id', {id}).get (meetup) ->
    $scope.meetup = meetup

.controller 'fullschedule', ($scope, $resource, $routeParams) ->
  {id} = $routeParams

  $resource('/api/fullschedule/:id', {id}).get (response) ->
    $scope.dates = response.dates

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
  # This could be inherited.
  $scope.meetup ?= {}

  modalController = ($scope, $resource, $modalInstance) ->

    modalClose = (reason) ->
      console.log 'close', reason

      $scope.meetup.saved = true
      $resource("/api2/meetups/#{$scope.meetup._id}").save $scope.meetup

    modalDismiss = (reason) ->
      console.log 'dismiss', reason

      # Only delete the modal if it's never been saved, or
      # if we're requesting deletion.
      if (!$scope.meetup.saved) or reason is 'delete'
        $resource("/api2/meetups/#{$scope.meetup._id}").delete()

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
