console.log 'HAI DENNY'

angular.module("sting.admin", ["ngResource", "ngRoute", "sting.edit"])
  .config [
    '$routeProvider', '$locationProvider',
    ($routeProvider, $locationProvider) ->
      $routeProvider

        .when '/question/:id',
          controller: 'EditController'
          templateUrl: '/../public/templates/admin/question.html'

        .when '/user',
          controller: 'UserController'
          templateUrl: '/../public/templates/admin/list.html'

        .when '/question',
          controller: 'QuestionController'
          templateUrl: '/../public/templates/admin/list.html'

        .when '/gender',
          controller: 'GenderController'
          templateUrl: '/../public/templates/admin/list.html'

        .otherwise
          controller: 'UserController'
          templateUrl: '/../public/templates/admin/list.html'
    ]
  .controller "UserController", [
    "$scope", "$resource"
    ($scope, $resource) ->

      $scope.add = () ->
        console.log "user add"

      $scope.remove = (index, id) ->
        resource = $resource '/api/user/:id', {id}
        resource.delete (err, thing) ->
          $scope.docs.splice(index,1)

      resource = $resource '/api/user', {}

      $scope.docs = []
      docs = resource.query {}, ->
        $scope.docs = docs

      $scope.tableheader = "Users"
      $scope.fields = ['email', 'admin']
      $scope.selected = "user"
  ]
  .controller "QuestionController", [
    "$scope", "$resource", "$location"
    ($scope, $resource, $location) ->

      # For this one may need an edit data service to carry
      # the edited object to the next controller without ajax
      #
      # May want to also reload object?? announce conflict?  hard.
      # Yeah and in the controller, we want to know whether we
      # navigated here, or whether we were loaded from list screen.
      #
      # If we were loaded from the list screen, use that, and compare
      # against data from server.  if nothing from list screen, just use
      # server.  If differences between original and ajax'd, user can
      # choose the server copy, but UNDO to go back to the memory copy,
      # and save to blow it all away.  Neat!
      $scope.add = () ->
        resource = $resource '/api/question/new'
        doc = resource.get {}, () ->
          $location.path '/question/'+doc._id

      $scope.remove = (index, id) ->
        resource = $resource '/api/question/:id', {id}
        resource.delete (err, thing) ->
          $scope.docs.splice(index,1)

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
          $scope.docs.splice(index,1)

      resource = $resource '/api/gender', {}

      $scope.docs = []
      docs = resource.query {}, ->
        $scope.docs = docs

      $scope.tableheader = "Genders"
      $scope.fields = ['label', 'code']
      $scope.selected = "gender"
  ]