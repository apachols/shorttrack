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
    "$scope", "$resource", '$routeParams', 'EditService'
    ($scope, $resource, $routeParams, EditService) ->

      {collection, _id} = $routeParams
      $scope.selected = collection

      $scope.templateUrl = '/../public/templates/admin/' + collection + '.html'

      if EditService.haveDocument()
        $scope.doc = $scope.original = EditService.getDocument()
      else
        $scope.doc = $scope.original = {}

      resource = $resource '/api/:collection', {collection, _id}
      response = resource.get {}, ->
        # can check here if db copy is different from edit service copy
        doc = response.docs[0]
        $scope.doc = angular.copy $scope.original = angular.copy doc

      $scope.save = () ->
        resource = $resource '/api/:collection/:_id', {collection, _id}

        resource.save $scope.doc, ->
          $scope.original = angular.copy $scope.doc

      $scope.undo = () ->
        $scope.doc = angular.copy $scope.original
  ]