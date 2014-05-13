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
                # Edit template not implmented yet, beware!
                collection: 'user'
                update: '/user/'
                api: '/api/user'
                tableheader: "Users"
                fields: ['email', 'admin']
              }

        .when '/question',
          controller: 'ListController'
          templateUrl: '/../public/templates/admin/list.html'
          resolve:
            config: () ->
              return {
                collection: 'question'
                update: '/question/'
                api: '/api/question'
                create: 'api/question/new'
                tableheader: "Match Questions"
                fields: ['name', 'text']
              }

        .when '/gender',
          controller: 'ListController'
          templateUrl: '/../public/templates/admin/list.html'
          resolve:
            config: () ->
              return {
                collection: 'gender'
                update: '/gender/'
                api: '/api/gender'
                create: '/api/gender/new'
                tableheader: "Genders"
                fields: ['label', 'code']
              }

        .otherwise
          redirectTo: '/user'
    ]

  # Fix 'selected' -> active class in list.jade
  #
  # Consolidate configs in provider/value/whatever
  # Use same configs for list and edit
  # Have EditService handle config, but do _id separately
  #   so that user can navigate to /collection/:id
  .controller "ListController", [
    '$scope', '$resource', 'config', 'EditService'
    ($scope, $resource, config, EditService) ->

      $scope.config = config

      $scope.docs = []
      resource = $resource config.api, {}
      response = resource.get {}, ->
        $scope.docs = response.docs

      $scope.update = (doc) ->
        EditService.edit doc, config

      $scope.add = () ->
        resource = $resource config.api + '/new'
        doc = resource.get {}, () ->
          EditService.edit doc, config

      $scope.remove = (index, id) ->
        resource = $resource config.api + '/:id', {id}
        resource.delete (err, thing) ->
          $scope.docs.splice(index,1)
  ]
  .constant "models", {
    user:
      list: '#/user'
      collection: 'user'
      update: '/user/'
      api: '/api/user'
      tableheader: "Users"
      fields: ['email', 'admin']
    question:
      list: '#/question'
      collection: 'question'
      update: '/question/'
      api: '/api/question'
      create: 'api/question/new'
      tableheader: "Match Questions"
      fields: ['name', 'text']
    gender:
      list: '#/gender'
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
      displayCollection: (name) ->
        current = models[name]
        $location.path current.list
   }
  .controller "AdminController", [
    '$scope', 'ListService'
    ($scope, ListService) ->
      $scope.goList = (name) ->
        ListService.displayCollection name
  ]