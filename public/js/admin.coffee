angular.module("sting.admin", ["ngResource", "ngRoute", "sting.edit"])
  .config [
    '$routeProvider', '$locationProvider'
    ($routeProvider, $locationProvider) ->
      $routeProvider

        .when '/user/:id',
          controller: 'EditController'
          # Template not implemented yet, beware!
          templateUrl: '/../public/templates/admin/user.html'
          resolve:
            config: ($route) ->
              return {
                '_id': $route.current.params.id
                collection: 'user'
              }

        .when '/question/:id',
          controller: 'EditController'
          templateUrl: '/../public/templates/admin/question.html'
          resolve:
            config: ($route) ->
              return {
                '_id': $route.current.params.id
                collection: 'question'
              }

        .when '/gender/:id',
          controller: 'EditController'
          templateUrl: '/../public/templates/admin/gender.html'
          resolve:
            config: ($route) ->
              return {
                '_id': $route.current.params.id
                collection: 'gender'
              }

        .when '/user',
          controller: 'ListController'
          templateUrl: '/../public/templates/admin/list.html'
          resolve:
            config: () ->
              return {
                collection: 'user'
              }

        .when '/question',
          controller: 'ListController'
          templateUrl: '/../public/templates/admin/list.html'
          resolve:
            config: () ->
              return {
                collection: 'question'
              }

        .when '/gender',
          controller: 'ListController'
          templateUrl: '/../public/templates/admin/list.html'
          resolve:
            config: () ->
              return {
                collection: 'gender'
              }

        .otherwise
          redirectTo: '/user'
    ]

  # Change so as to not default to user upon navigation
  # I feel dumb lol, waiting till morning to figure this out.
  #
  # Use same configs for list and edit
  # Have EditService handle config, but do _id separately
  #   so that user can navigate to /collection/:id
  .controller "ListController", [
    '$scope', '$resource', 'ListService', 'EditService'
    ($scope, $resource, ListService, EditService) ->

      $scope.config = ListService.getCurrent()
      console.log $scope.config

      $scope.docs = []
      resource = $resource $scope.config.api, {}
      response = resource.get {}, ->
        $scope.docs = response.docs

      $scope.update = (doc) ->
        EditService.edit doc, $scope.config

      $scope.add = () ->
        resource = $resource $scope.config.api + '/new'
        doc = resource.get {}, () ->
          EditService.edit doc, $scope.config

      $scope.remove = (index, id) ->
        resource = $resource $scope.config.api + '/:id', {id}
        resource.delete (err, thing) ->
          $scope.docs.splice(index,1)
  ]
  .constant "models", {
    user:
      list: '/user'
      collection: 'user'
      update: '/user/'
      api: '/api/user'
      tableheader: "Users"
      fields: ['email', 'admin']
    question:
      list: '/question'
      collection: 'question'
      update: '/question/'
      api: '/api/question'
      create: 'api/question/new'
      tableheader: "Match Questions"
      fields: ['name', 'text']
    gender:
      list: '/gender'
      collection: 'gender'
      update: '/gender/'
      api: '/api/gender'
      create: '/api/gender/new'
      tableheader: "Genders"
      fields: ['label', 'code']
   }
  .factory "ListService", ($location, models) ->
    current = undefined
    return {
      hasCurrent: () -> current?

      getCurrent: () -> current

      displayCollection: (name) ->
        current = models[name]
        console.log 'current', current
        $location.path current.list
   }
  .controller "AdminController", [
    '$scope', 'ListService'
    ($scope, ListService) ->
      $scope.goList = (name) ->
        $scope.selected = name
        ListService.displayCollection name

      $scope.goList 'user' if not ListService.hasCurrent()
  ]