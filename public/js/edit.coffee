angular.module("edit", ["ngResource"])
  .controller "EditController", [
    "$scope", "$resource", '$window',
    ($scope, $resource, $window) ->

      {collection, fields, _id} = $scope.config
      resource = $resource '/api/:collection', {collection, _id}

      # This DB query should be replaced by object -> route provider?
      original = {}
      docs = resource.query {}, ->
        $scope.doc = docs[0]
        original = angular.copy $scope.doc

      $scope.save = () ->
        setQuery = {}
        for field in fields
          setQuery[field] = $scope.doc[field]

        resource = $resource '/api/:collection/:_id', {collection, _id}

        # This redirect on save DEFINITELY needs to be replaced by routeProvider
        resource.save setQuery, ->
          $window.location = '/admin/#'+collection

      $scope.undo = () ->
        $scope.doc = angular.copy original
  ]