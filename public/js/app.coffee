angular.module 'sting', [
  'ui.bootstrap'
  'sting.forgot'
  'sting.admin'
  'sting.edit'
  'sting.profile'
  'sting.meetups'
  'ui-rangeSlider'
]

angular.module 'sting.meetups', ['ngResource', 'ngRoute']
.config ($routeProvider) ->
  $routeProvider

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

.controller 'userlist', ($scope, $resource, $routeParams) ->
  {id} = $routeParams
  $scope.paid = {}
  $resource('/api/userlist/:id', {id}).get (response) ->
    $scope.registered = response.registered
    for uid in response.paid
      $scope.paid[response.paid]
    console.log $scope.registered, $scope.paid

.controller 'meetupModal', ($scope, $modal, $resource, $routeParams) ->
  $scope.meetup = {}

  $scope.open = ->
    # $resource('/api2/meetups').save {name: ''}, (meetup) ->
    #   $scope.meetup = meetup

    id = '5376be1429aa94b283508e6d'
    $resource('/api2/meetups/:id', {id}).get (meetup) ->
      $scope.meetup = meetup

    modalInstance = $modal.open
      templateUrl: '/public/templates/meetups/modal.html'
      controller: 'meetupModify'
      scope: $scope

.controller 'meetupModify', ($scope, $modalInstance) ->
  $scope.cancel = -> $modalInstance.dismiss('cancel')
