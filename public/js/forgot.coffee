angular.module 'sting.forgot', [
  'ngResource'
]

.controller 'forgotPassword', ($scope, $modal) ->

  $scope.startProcess = ->
    modalInstance = $modal.open
      templateUrl: '/public/templates/forgot-password.html'
      controller: 'modalController'

.controller 'modalController', ($scope, $modalInstance, $http) ->
  $scope.alerts = []

  $scope.cancel = ->
    $modalInstance.dismiss 'cancel'

  $scope.requestToken = (email) ->
    $http.post '/forgot', {email}
    .success ->
      $scope.alerts.push
        type: 'success'
        msg: "Instructions to reset your password have been sent to #{email}"
      return

  $scope.closeAlert = (index) ->
    $scope.alerts.splice index, 1
