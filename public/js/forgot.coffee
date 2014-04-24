angular.module 'sting.forgot', [
  'ngResource'
  'ngRoute'
]

.controller 'forgotPassword', ($scope, $modal) ->
  $scope.startProcess = ->
    modalInstance = $modal.open
      templateUrl: '/public/templates/forgotPassword.html'
      controller: 'modalController'

.controller 'modalController', ($scope, $modalInstance, $http) ->
  $scope.alerts = []

  $scope.cancel = -> $modalInstance.dismiss 'cancel'
  $scope.requestToken = (email) ->
    $http.post '/forgot', {email: 'sorahn@gmail.com'}
    .success ->
      $scope.alerts.push
        type: 'success'
        msg: "Instructions to reset your password have been sent to #{email}"
      return
  $scope.closeAlert = (index) ->
    $scope.alerts.splice index, 1
