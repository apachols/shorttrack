angular.module("sting.edit", ["ngResource"])
  .controller "EditController", [
    "$scope", "$resource", '$window',
    ($scope, $resource, $window) ->

      {collection, fields, _id} = $scope.config

      $scope.doc = $scope.original = {}

      # What we should do at this point:
      # - Add route provider
      # - Put the edit screens where the list lives
      # - Pass selected object between scopes on edit
      # - On add, create object and then edit it
      # - For user, EVENTUALLY use new user edit template for profile page :D

      # Bad!  We are parsing the jade file with no id, and so it comes out
      # as string 'undefined'... fix with actual single pageness
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