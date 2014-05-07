angular.module("sting.profile", ["ngResource", "checklist-model"])
  .controller "ProfileController", [
    "$scope", "$resource",
    ( $scope, $resource ) ->
      console.log "ProfileController"

      $scope.getGenders = () ->
        resource = $resource '/api/gender'
        genders = resource.query {}, ->
          $scope.genders = genders

      $scope.getProfile = () ->
        resource = $resource '/api/profile'
        response = resource.get {}, ->
          $scope.doc =
            email: response.email
            profile: response.profile

          console.log response.profile.age.my

          console.log $scope.doc

      $scope.save = (newdoc, olddoc) ->
        console.log 'directive save', newdoc, olddoc
        resource = $resource '/api/profile'
        resource.save newdoc

      $scope.doc = {}
      $scope.getGenders()
      $scope.getProfile()

  ]
  .directive "autosave", [ () ->
    return {
      restrict: 'A'
      link: (scope, element, attrs) ->
        scope.$watch attrs.model, _.debounce(scope.save, 1000), true
    }
  ]
  .directive 'slider', ['$parse', ($parse) ->
    return {
      restrict: 'A'
      link: ($scope, element, attrs) ->
        model = $parse attrs.model

        slider = $(element[0]).slider
          'value': model($scope)

        slider.on 'slide', (ev) ->
          model.assign $scope, ev.value
          $scope.$apply()
    }
  ]

