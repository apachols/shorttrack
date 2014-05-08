angular.module("sting.profile", ["ngResource", "checklist-model"])
  .controller "ProfileController", [
    "$scope", "$resource",
    ( $scope, $resource ) ->
      console.log "ProfileController"

      # idea:  merge the ANSWERED questions from profile with the NEW questions
      #        from question, after both are retrieved.  Put these in profile.questions.
      #
      # http://lodash.com/docs#uniq
      #
      # Can a user get skip a question?  skip button -> clear answer
      # Can a user get rid of an unanswered question? unanswered questions aren't saved
      # How to tell if a particular answer is checked?
      # What if answers change?  Could have stranded records for users.
      # This needs some help.  Maybe changing answers is really bad, even if it were normalized.
      # OK - NEED
      #   questions section is a question pager directive(ng-repeat!), fetches own records on page-turn
      #   answer is populated from user's answers (keep a key-value store in memory?)
      #   when user changes question (answer (ng-repeat!), importance(ng-repeat!), acceptable(ng-repeat!))
      #     updates the profile record's matching question
      #
      #   Cannot do question answering via separate ajax, updating same profile record.  in memory.
      #

      # $scope.getQuestions = () ->
      #   resource = $resource '/api/question'
      #   questions = resource.query {}, ->
      #     $scope.questions = questions
      #     console.log questions

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

        # $scope.getQuestions()

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

