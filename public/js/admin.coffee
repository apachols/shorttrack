console.log 'HAI DENNY'

angular.module("sting.admin", ["sting.adminServices", "ngResource"])
  .controller "AdminController", [
    "$scope", "user", "question", "gender", "$resource"
    ($scope, user, question, gender, $resource) ->

      $scope.getResource = (model) ->
        console.log "getResource", model
        switch model
          when "user"
            user
          when "question"
            question
          when "gender"
            gender
          else
            null

      $scope.add = (model) ->
        resource = $resource '/api/:model', {model}
        resource.delete (err, thing) ->
          $scope.docs.splice(index)

      $scope.remove = (index, model, id) ->
        resource = $resource '/api/:model/:id', {model, id}
        resource.delete (err, thing) ->
          $scope.docs.splice(index)

      # select a model and fetch records from the db
      $scope.select = (model) ->
        $scope.selected = model

        resource = $scope.getResource(model)
        switch model
          when "user"
            $scope.tableheader = "Users"
            $scope.fields = ['email', 'admin']
          when "question"
            $scope.tableheader = "Match Questions"
            $scope.fields = ['name', 'text']
          when "gender"
            $scope.tableheader = "Genders"
            $scope.fields = ['label', 'code']

        $scope.docs = []
        docs = resource.query {}, ->
          $scope.docs = docs

      $scope.docs = []
      $scope.fields = []
      $scope.select 'user'
  ]

angular.module("sting.adminServices", ["ngResource"])

  .factory "user", ($resource) ->
    $resource '/api/user', {}

  .factory "question", ($resource) ->
    $resource '/api/question', {}

  .factory "gender", ($resource) ->
    $resource '/api/gender', {}