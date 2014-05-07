angular.module("sting.profile", ["ngResource", "checklist-model"])
  .controller "ProfileController", [
    "$scope", "$resource",
    ( $scope, $resource ) ->
      console.log "ProfileController"

      $scope.getQuestions = () ->
        resource = $resource '/api/question'
        questions = resource.query {}, ->
          $scope.questions = questions
          console.log questions

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

          console.log $scope.doc

      $scope.save = (newdoc, olddoc) ->
        console.log 'directive save', newdoc, olddoc
        resource = $resource '/api/profile'
        resource.save newdoc

      $scope.doc = {}
      $scope.getQuestions()
      $scope.getGenders()
      $scope.getProfile()

  ]
  .directive "autosave", [ () ->
    return {
      restrict: 'A'
      link: (scope, element, attrs) ->
        savefn = (newdoc, olddoc) ->
          scope.save(newdoc, olddoc) if olddoc
        scope.$watch attrs.model, _.debounce(savefn, 1000), true
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

