angular.module("sting.edit", ["ngResource"])
  .controller "EditController", [
    "$scope", "$resource", '$window', 'config'
    ($scope, $resource, $window, config) ->
      console.log "config", config

      {collection, fields, _id} = config

      $scope.doc = $scope.original = {}

      resource = $resource '/api/:collection', {collection, _id}
      docs = resource.query {}, ->
        $scope.doc = angular.copy $scope.original = angular.copy docs[0]

      $scope.save = () ->
        setQuery = {}
        for field in fields
          setQuery[field] = $scope.doc[field]

        console.log 'have id', _id
        resource = $resource '/api/:collection/:_id', {collection, _id}

        resource.save setQuery, ->
          $scope.original = angular.copy $scope.doc
          $scope.editform.$setPristine()

      $scope.undo = () ->
        $scope.doc = angular.copy $scope.original
        $scope.editform.$setPristine()
  ]