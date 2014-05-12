angular.module("sting.edit", ["ngResource"])

  .factory "EditService", ($location) ->
    record = undefined
    return {
      haveDocument: () -> record?

      getDocument: () -> return record

      edit: (doc, config) ->
        record = doc
        $location.path config.update + record._id
   }

  .controller "EditController", [
    "$scope", "$resource", '$window', 'config', 'EditService'
    ($scope, $resource, $window, config, EditService) ->

      {collection, fields, _id} = config

      if EditService.haveDocument()
        $scope.doc = $scope.original = EditService.getDocument()
      else
        $scope.doc = $scope.original = {}

      resource = $resource '/api/:collection', {collection, _id}
      docs = resource.query {}, ->
        # can check here if db copy is different from edit service copy
        $scope.doc = angular.copy $scope.original = angular.copy docs[0]

      $scope.save = () ->
        setQuery = {}
        for field in fields
          setQuery[field] = $scope.doc[field]

        resource = $resource '/api/:collection/:_id', {collection, _id}

        resource.save setQuery, ->
          $scope.original = angular.copy $scope.doc
          $scope.editform.$setPristine()

      $scope.undo = () ->
        $scope.doc = angular.copy $scope.original
        $scope.editform.$setPristine()
  ]