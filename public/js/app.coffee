angular.module 'sting', [
  'ui.bootstrap'
  'sting.forgot'
  # 'sting.admin'
  # 'sting.edit'
  # 'sting.profile'
  'sting.homepage'
  'sting.meetups'
  'ui-rangeSlider'
]

angular.module 'sting.homepage', ['ngResource']
.controller 'upcoming', ($scope, $resource) ->
  $resource('/api2/meetups').query (meetups) ->
    $scope.meetups = meetups


angular.module 'sting.meetups', ['ngResource', 'ngRoute']
.controller 'meetups', ($scope, $resource) ->

  id = '536aed82a8fe4cadae8249a3'
  $resource('/api2/meetups/:id', {id}).get (meetup) ->
    $scope.meetup = meetup
