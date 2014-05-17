angular.module("sting.admin", ["ngResource", "ngRoute", "sting.edit"])
  .config [
    '$routeProvider', '$locationProvider'
    ($routeProvider, $locationProvider) ->
      $routeProvider
        .when '/admin/:collection/:_id',
          controller: 'EditController'
          template: '<div ng-include src="templateUrl"></div>'

        .when '/admin/:collection?',
          controller: 'ListController'
          templateUrl: '/../public/templates/admin/list.html'
    ]

  .controller "ListController", [
    '$scope', '$resource', 'models','EditService', '$routeParams'
    ($scope, $resource, models, EditService, $routeParams) ->

      {collection} = $routeParams
      collection = collection || 'user'

      $scope.selected = collection

      $scope.config = models[collection]

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
      update: '/admin/user/'
      api: '/api/user'
      tableheader: "Users"
      fields: ['email', 'admin']
    question:
      list: '/question'
      collection: 'question'
      update: '/admin/question/'
      api: '/api/question'
      create: 'api/question/new'
      tableheader: "Match Questions"
      fields: ['name', 'text']
    gender:
      list: '/gender'
      collection: 'gender'
      update: '/admin/gender/'
      api: '/api/gender'
      create: '/api/gender/new'
      tableheader: "Genders"
      fields: ['label', 'code']
   }
