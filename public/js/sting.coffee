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

.run ($window, $rootScope) ->
  if $window.sting.admin
    $rootScope.isAdmin = true