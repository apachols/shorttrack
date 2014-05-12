angular.module("sting.edit", ["ngResource"])
  .controller "EditController", [
    "$scope", "$resource", '$window',
    ($scope, $resource, $window) ->

      $scope.config =
        '_id': '535c5e532f1169ab615d1ac9'
        collection: 'question'
        fields: ['text','name','answers']

      {collection, fields, _id} = $scope.config

      $scope.doc = $scope.original = {}

      if _id isnt 'undefined'
        console.log "id = ", _id
        resource = $resource '/api/:collection', {collection, _id}
        docs = resource.query {}, ->
          $scope.doc = angular.copy $scope.original = angular.copy docs[0]

      $scope.save = () ->
        setQuery = {}
        for field in fields
          setQuery[field] = $scope.doc[field]

        if _id isnt 'undefined'
          console.log 'have id', _id
          resource = $resource '/api/:collection/:_id', {collection, _id}
        else
          console.log 'new record'
          resource = $resource '/api/:collection', {collection}

        resource.save setQuery, ->
          $scope.original = angular.copy $scope.doc
          $scope.editform.$setPristine()

      $scope.undo = () ->
        $scope.doc = angular.copy $scope.original
        $scope.editform.$setPristine()
  ]