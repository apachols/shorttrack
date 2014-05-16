angular.module 'sting', [
  'ui.bootstrap'
  'sting.forgot'
  # 'sting.admin'
  # 'sting.edit'
  # 'sting.profile'
  'sting.meetups'
  'ui-rangeSlider'
]

angular.module 'sting.meetups', ['ngResource', 'ngRoute']
.config ($routeProvider) ->
  $routeProvider
    .when '/meetup/:id',
      controller: 'meetup'
      templateUrl: '/public/templates/meetup.html'

    .otherwise
      controller: 'upcoming'
      templateUrl: '/public/templates/upcoming.html'

.controller 'upcoming', ($scope, $resource) ->
  $resource('/api2/meetups').query (meetups) ->
    $scope.meetups = meetups

.controller 'meetup', ($scope, $resource, $routeParams) ->
  {id} = $routeParams
  $resource('/api2/meetups/:id', {id}).get (meetup) ->
    $scope.meetup = meetup
    console.log meetup
