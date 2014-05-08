console.log 'HAI DENNY'

angular.module("sting.admin", ["ngResource", "ngRoute"])
  .config [
    '$routeProvider', '$locationProvider',
    ($routeProvider, $locationProvider) ->
      $routeProvider

        .when '/user',
          controller: 'UserController'
          templateUrl: 'list.html'

        .when '/question',
          controller: 'QuestionController'
          templateUrl: 'list.html'

        .when '/gender',
          controller: 'GenderController'
          templateUrl: 'list.html'

        .otherwise
          controller: 'UserController'
          templateUrl: 'list.html'
    ]
  .controller "UserController", [
    "$scope", "$resource"
    ($scope, $resource) ->

      $scope.add = () ->
        console.log "user add"

      $scope.remove = (index, id) ->
        resource = $resource '/api/user/:id', {id}
        resource.delete (err, thing) ->
          $scope.docs.splice(index)

      resource = $resource '/api/user', {}

      $scope.docs = []
      docs = resource.query {}, ->
        $scope.docs = docs

      $scope.tableheader = "Users"
      $scope.fields = ['email', 'admin']
      $scope.selected = "user"
  ]
  .controller "QuestionController", [
    "$scope", "$resource"
    ($scope, $resource) ->

      $scope.add = () ->
        resource = $resource '/api/question/new'
        doc = resource.get {}, () ->
          console.log "add complete", doc

      $scope.remove = (index, id) ->
        resource = $resource '/api/question/:id', {id}
        resource.delete (err, thing) ->
          $scope.docs.splice(index)

      resource = $resource '/api/question', {}

      $scope.docs = []
      docs = resource.query {}, ->
        $scope.docs = docs

      $scope.tableheader = "Match Questions"
      $scope.fields = ['name', 'text']
      $scope.selected = "question"
  ]
  .controller "GenderController", [
    "$scope", "$resource"
    ($scope, $resource) ->

      $scope.add = () ->
        console.log "gender add"

      $scope.remove = (index, id) ->
        resource = $resource '/api/gender/:id', {id}
        resource.delete (err, thing) ->
          $scope.docs.splice(index)

      resource = $resource '/api/gender', {}

      $scope.docs = []
      docs = resource.query {}, ->
        $scope.docs = docs

      $scope.tableheader = "Genders"
      $scope.fields = ['label', 'code']
      $scope.selected = "gender"
  ]