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
                fields: ['email','relations']
              }

        .when '/question/:id',
          controller: 'EditController'
          templateUrl: '/../public/templates/admin/question.html'
          resolve:
            config: ($route) ->
              return {
                '_id': $route.current.params.id
                collection: 'question'
                fields: ['text','name','answers']
              }

        .when '/gender/:id',
          controller: 'EditController'
          templateUrl: '/../public/templates/admin/gender.html'
          resolve:
            config: ($route) ->
              return {
                '_id': $route.current.params.id
                collection: 'gender'
                fields: ['label','code']
              }

        .when '/user',
          controller: 'ListController'
          templateUrl: '/../public/templates/admin/list.html'
          resolve:
            config: () ->
              return {
                # Edit template not implmented yet, beware!
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
                update: '/gender/'
                api: '/api/gender'
                create: '/api/gender/new'
                tableheader: "Genders"
                fields: ['label', 'code']
              }

        .otherwise
          redirectTo: '/user'
    ]

  # Get rid of fields in edit / update query
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
      docs = resource.query {}, ->
        $scope.docs = docs

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