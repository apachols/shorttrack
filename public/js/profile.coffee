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

      $scope.status =
        allQuestionsSeen: false

      $scope.getQuestions = () ->
        resource = $resource '/api/question'
        response = resource.get {}, ->
          $scope.questions = response.docs

          $scope.getNewQuestion()

      $scope.getGenders = () ->
        resource = $resource '/api/gender'
        response = resource.get {}, ->
          $scope.genders = response.docs

      $scope.getProfile = () ->
        resource = $resource '/api/profile'
        response = resource.get {}, ->
          console.log response
          $scope.doc =
            email: response.email
            profile: response.profile
          console.log $scope.doc

        $scope.getQuestions()

      $scope.getNewQuestion = () ->
        console.log "getNewQuestion called"
        # $scope.questionIndex++
        # here we do some logic to make sure we don't have an answered question

        next = $scope.nextQuestion()
        if next == -1
          $scope.status.allQuestionsSeen = true
          $scope.questionIndex = -1
          next = $scope.nextQuestion()

        $scope.currentQuestion = next

        # set up current answer object
        # TODO need to fix this for previously answered questions
        currentAnswer = 
          question: $scope.currentQuestion._id
          answer: null
          acceptable: []
          importance: null

        $scope.currentAnswer = currentAnswer

      $scope.nextQuestion = () ->

        $scope.questionIndex++

        for question in $scope.questions[$scope.questionIndex..]
          matchingAnswer = $scope.doc.profile.answers.filter (x) -> x.question == question._id

          # if user hasn't seen all the questions, return the first
          # non-matching question. else, return the first question the user's
          # already answered.
          if !$scope.status.allQuestionsSeen
            return question if matchingAnswer.length == 0
          else
            return question if matchingAnswer.length > 0

          # only increment on questions we already answered.
          # otherwise, we increment next time we come through this function
          $scope.questionIndex++
        return -1

      $scope.saveAnswer = () ->
        # handle question skipping
        if $scope.currentAnswer.answer
          # TODO this should never happen if the model is set up correctly
          $scope.doc.profile.answers = [] unless $scope.doc.profile.answers

          # filter out nulls
          $scope.currentAnswer.acceptable = (txt for txt in $scope.currentAnswer.acceptable when txt) 
          $scope.doc.profile.answers.push($scope.currentAnswer)
        # else
        #   console.log 'skipped!'

        $scope.getNewQuestion()


      $scope.save = (newdoc, olddoc) ->
        console.log 'directive save', newdoc, olddoc
        resource = $resource '/api/profile'
        resource.save newdoc

      $scope.doc = {}
      $scope.genders = []
      #$scope.currentQuestion = "some question"

      $scope.questionIndex = -1
      #$scope.currentAnswer = null

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

