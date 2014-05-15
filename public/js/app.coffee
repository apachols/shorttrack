angular.module 'sting', [
  'ui.bootstrap'
  'sting.forgot'
  'sting.admin'
  'sting.edit'
  'sting.profile'
  'sting.homepage'
  'ui-rangeSlider'
]

angular.module 'sting.homepage', ['ngResource']
.controller 'upcoming', ($scope, $location, $resource) ->
  Meetup = $resource '/api2/meetups', {id: '@_id'}

  Meetup.query {}, (meetups) ->
    $scope.meetups = meetups
