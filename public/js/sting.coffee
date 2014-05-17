angular.module 'sting', [
  'ui.bootstrap'
  'sting.forgot'
  'sting.admin'
  'sting.edit'
  'sting.profile'
  'sting.meetups'
  'ui-rangeSlider'
  'vr.directives.slider'
]

angular.module 'sting.meetups', ['ngResource', 'ngRoute']
.config ($routeProvider) ->
  $routeProvider

    .when '/meetup/:id/fullschedule',
      controller: 'fullschedule'
      templateUrl: '/public/templates/meetups/fullschedule.html'

    .when '/meetup/:id/userlist',
      controller: 'userlist'
      templateUrl: '/public/templates/meetups/userlist.html'

    .when '/meetup/:id',
      controller: 'meetup'
      templateUrl: '/public/templates/meetup.html'

    .otherwise
      controller: 'upcoming'
      templateUrl: '/public/templates/upcoming.html'

.controller 'upcoming', ($scope, $resource) ->
  $resource('/api2/meetups/').query (meetups) ->
    $scope.meetups = meetups

.controller 'meetup', ($scope, $resource, $routeParams) ->
  {id} = $routeParams
  $resource('/api2/meetups/:id', {id}).get (meetup) ->
    $scope.meetup = meetup
    console.log meetup

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

.controller 'meetupCreate', ($scope, $modal, $resource) ->

  $scope.meetup = {}

  modalController = ($scope, $resource, $modalInstance) ->
    $scope.minDate = new Date()
    $scope.cancel = -> $modalInstance.dismiss()
    $scope.save = -> $modalInstance.close()

    $modalInstance.result.then (reason) ->
      console.log 'close', reason
      $resource("/api2/meetups/#{$scope.meetup._id}").save $scope.meetup
    , (reason) ->
      console.log 'dismiss', reason
      $resource("/api2/meetups/#{$scope.meetup._id}").delete()

  $scope.open = ->
    $resource('/api2/meetups').save {name: ''}, (meetup) ->
      $scope.meetup = meetup

    modalInstance = $modal.open
      scope: $scope
      templateUrl: '/public/templates/meetups/modal.html'
      controller: modalController
