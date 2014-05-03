angular.module("sting.profile", ["ngResource"])
  .controller "ProfileController", [
    "$scope", "$resource",
    ( $scope, $resource ) ->
      console.log "ProfileController"

      $scope.doc = {}

      resource = $resource '/api/profile'
      $scope.save = (newdoc, olddoc) ->
        console.log 'directive save', olddoc, newdoc
        resource.save newdoc

      response = resource.get {}, ->
        $scope.doc =
          email: response.email
          profile: response.profile

        console.log $scope.doc
  ]
  .directive "autosave", [ () ->
    return {
      restrict: 'A'
      link: (scope, element, attrs) ->
        scope.$watch 'doc.profile', scope.save, true
    }
  ]