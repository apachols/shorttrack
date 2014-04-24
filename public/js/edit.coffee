angular.module("edit", ["ngResource"])
  .controller "EditController", [
    "$scope", "$resource", '$window',
    ($scope, $resource, $window) ->

      console.log $scope.config

      {collection, fields, id} = $scope.config
      resource = $resource '/api/:collection/:id', {collection, id}

      original = {}

      $scope.undo = () ->
        $scope.doc = angular.copy original

      $scope.save = () ->
        setQuery = {}
        for field in fields
          setQuery[field] = $scope.doc[field]

        resource.save setQuery, ->
          $window.location = '/admin/#'+collection

      doc = resource.get {}, ->
        original = angular.copy doc
        $scope.doc = doc
  ]