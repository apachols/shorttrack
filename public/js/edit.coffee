angular.module("edit", ["ngResource"])
  .controller "EditController", [
    "$scope", "$resource", '$window',
    ($scope, $resource, $window) ->

      {collection, fields, _id} = $scope.config
      resource = $resource '/api/:collection', {collection, _id}

      # This DB query should be replaced by object -> route provider?
      $scope.doc = $scope.original = {}
      docs = resource.query {}, ->
        $scope.doc = angular.copy $scope.original = angular.copy docs[0]

      $scope.save = () ->
        setQuery = {}
        for field in fields
          setQuery[field] = $scope.doc[field]

        resource = $resource '/api/:collection/:_id', {collection, _id}

        resource.save setQuery, ->
          $scope.original = $scope.doc

      $scope.undo = () ->
        $scope.doc = angular.copy $scope.original
        $scope.editform.$setPristine()
  ]