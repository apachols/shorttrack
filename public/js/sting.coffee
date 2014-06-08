angular.module 'sting', [
  'ui.bootstrap'
  'sting.forgot'
  'sting.admin'
  'sting.edit'
  'sting.profile'
  'sting.meetups'
  'ui-rangeSlider'
]

.config ($routeProvider) ->
  $routeProvider
    .when '/meetup/:id/userschedule',
      template: '<user-schedule>'

    .when '/meetup/:id/fullschedule',
      controller: 'fullschedule'
      templateUrl: '/public/templates/meetups/fullschedule.html'

    .when '/meetup/:id/userlist',
      controller: 'userlist'
      templateUrl: '/public/templates/meetups/userlist.html'

    .when '/meetup/:id',
      controller: 'meetup'
      templateUrl: '/public/templates/meetups/one.html'

    .otherwise
      controller: 'upcoming'
      templateUrl: '/public/templates/upcoming.html'

.run ($window, $rootScope) ->
  if $window.sting && $window.sting.admin
    $rootScope.isAdmin = truncate

.filter 'addEllipsis', ($filter) ->
  (string = '', truncate, custom = 300) ->

    if truncate and string and string.length > custom
      string = "#{$filter('limitTo') string, custom}..."

    else return string

.controller 'adminList', ($scope, $location) ->
  $scope.$on '$routeChangeSuccess', ->
    for path in ['user', 'gender', 'meetup', 'question']
      if -1 isnt $location.path().indexOf path
        $scope.selected = path
        console.log path
        break
